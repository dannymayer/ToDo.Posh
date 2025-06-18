function Update-Todo
{
  <#
    .SYNOPSIS
    Modifies the text of an existing task in the todo.txt file.

    .DESCRIPTION
    Locates a task by its line number and replaces its content with the updated string. The file is re-saved and reindexed afterward.

    .PARAMETER LineNumber
    The line number of the task to update.

    .PARAMETER NewText
    The updated task text to replace the existing one.

    .PARAMETER FilePath
    Optional path override for the todo.txt file.

    .EXAMPLE
    Update-Todo -LineNumber 2 -NewText "Refactor backup script @dev +PowerShell"

    .NOTES
    This does not automatically update dates, priorities, or metadata.
    #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [int]$LineNumber,

    [Parameter(Mandatory)]
    [string]$NewText,

    [string]$FilePath = (Get-ModuleSetting -Name 'TaskFilePath')
  )

  $tasks = Read-ToDoFile -Path $FilePath
  $target = $tasks | Where-Object { $_.LineNumber -eq $LineNumber }

  if (-not $target)
  {
    Write-Warning "Task at line $LineNumber not found."
    return
  }

  $target.Raw = $NewText.Trim()
  $tasks = $tasks | Sort-Object LineNumber

  Write-TodoFile -Tasks $tasks -Path $FilePath

  [PSCustomObject]@{
    Status     = 'Updated'
    Line       = $LineNumber
    NewContent = $target.Raw
    FilePath   = $FilePath
  }
}

