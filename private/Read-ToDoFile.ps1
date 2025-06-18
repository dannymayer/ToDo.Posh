function Read-ToDoFile
{
  <#
    .SYNOPSIS
    Reads and parses the todo.txt file into structured task objects.

    .DESCRIPTION
    Returns a list of tasks, with each line represented as a PowerShell object. 
    Attempts to extract basic metadata like created date and priority.

    .PARAMETER Path
    The path to the todo.txt file. Defaults to the value configured in TaskFilePath.

    .OUTPUTS
    An array of task objects with Raw, CreatedDate, Priority, Text, and metadata fields.

    .EXAMPLE
    Read-ToDoFile -Path "$HOME/todo.txt"

    .NOTES
    More parsing enhancements to follow (project/context extraction, etc.).
    #>
  [CmdletBinding()]
  param (
    [string]$Path = (Get-ModuleSetting -Name 'TaskFilePath')
  )

  if (-not (Test-Path $Path))
  {
    Write-Warning "ToDo file not found at $Path"
    return @()
  }

  $lines = Get-Content -Path $Path
  $tasks = @()
  $lineNumber = 1

  foreach ($line in $lines)
  {
    $createdDate = $null
    $priority = $null

    if ($line -match '^(\d{4}-\d{2}-\d{2})')
    {
      $createdDate = $matches[1]
    }

    if ($line -match '^\(([A-Z])\)')
    {
      $priority = $matches[1]
    }

    $tasks += [PSCustomObject]@{
      LineNumber   = $lineNumber
      Raw          = $line
      FilePath     = $Path
      CreatedDate  = $createdDate
      Priority     = $priority
      Text         = $line
    }

    $lineNumber++
  }

  return $tasks
}

