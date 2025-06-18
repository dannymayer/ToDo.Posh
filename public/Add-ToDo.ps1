function Add-Todo
{
  <#
    .SYNOPSIS
    Adds a new task to the todo.txt file.

    .DESCRIPTION
    Appends a formatted task string to the configured task file. Supports optional metadata like priority and automatic date prefixing.

    .PARAMETER Text
    The text of the task.

    .PARAMETER Priority
    Optional priority (A-Z).

    .EXAMPLE
    Add-Todo -Text "Call mom @phone +Family" -Priority A

    .NOTES
    Honors DateOnAdd and BackupOnWrite settings.
    #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]$Text,

    [ValidatePattern("^[A-Z]$")]
    [string]$Priority
  )

  $taskFile = Get-ModuleSetting -Name 'TaskFilePath'
  $dateOnAdd = Get-ModuleSetting -Name 'DateOnAdd'
  $backup = Get-ModuleSetting -Name 'BackupOnWrite'

  if (-not (Test-Path $taskFile))
  {
    New-Item -ItemType File -Path $taskFile -Force | Out-Null
  }

  if ($backup)
  {
    Copy-Item -Path $taskFile -Destination "$taskFile.bak" -Force
  }

  $raw = ""

  if ($Priority)
  {
    $raw += "($Priority) "
  }

  if ($dateOnAdd)
  {
    $raw += "$(Get-Date -Format yyyy-MM-dd) "
  }

  $raw += $Text.Trim()

  $lines = @()
  $lines += $raw
  Add-Content -Path $taskFile -Value $lines

  $lineCount = (Get-Content -Path $taskFile).Count

  [PSCustomObject]@{
    Raw         = $raw
    CreatedDate = if ($dateOnAdd)
    { Get-Date -Format yyyy-MM-dd 
    } else
    { $null 
    }
    LineNumber  = $lineCount
    FilePath    = $taskFile
  }
}

