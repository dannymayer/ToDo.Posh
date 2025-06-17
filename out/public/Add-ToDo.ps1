function Add-Todo
{
  <#
    .SYNOPSIS
    Adds a new task to the todo.txt file.
    .DESCRIPTION
    This cmdlet constructs a new task from the provided text, optionally prepending the creation date (if enabled),
    validates the task object, reads the existing todo list, appends the new task, and writes it back.
    .PARAMETER Text
    The text of the task to add (including any "+project", "@context", "(A)" priority, etc.).
    .OUTPUTS
    PSCustomObject representing the added task, with properties: Raw, LineNumber, FilePath.
    .EXAMPLE
    Add-Todo -Text "Buy milk +Groceries @Store"
    #>

  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]$Text
  )

  # Resolve the path to todo.txt
  $todoPath = Get-TodoFilePath -FileName 'todo.txt'
  if (-not $todoPath)
  {
    Write-Error "Could not determine path to todo.txt"
    return
  }

  # Optionally prepend date
  if ($PSBoundParameters.DateOnAdd -or (Get-ModuleSetting -Name 'DateOnAdd'))
  { 
    $date = (Get-Date).ToString('yyyy-MM-dd')
    $raw = "$date $Text"
  } else
  {
    $raw = $Text
  }

  # Build task object
  $task = [PSCustomObject]@{
    Raw        = $raw
    CreatedDate = if ($PSBoundParameters.DateOnAdd)
    { [datetime]$date 
    } else
    { $null 
    }
  }

  # Validate
  if (-not (Confirm-TodoTask -Task $task))
  {
    Write-Error "Task validation failed."
    return
  }

  # Read current tasks
  $lines = Read-TodoFile -Path $todoPath

  # Append new task
  $lines += $raw

  # Write back
  Write-TodoFile -Path $todoPath -Lines $lines

  # Determine line number
  $lineNumber = $lines.Count

  # Logging
  New-ToDoLogMessage -Message "Added task to line $lineNumber\: $raw" -Level Info

  # Output structured task object
  $task | Add-Member -NotePropertyName LineNumber -NotePropertyValue $lineNumber -Force
  $task | Add-Member -NotePropertyName FilePath -NotePropertyValue $todoPath -Force

  return $task
}

Export-ModuleMember -Function Add-ToDo
