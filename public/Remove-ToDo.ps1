function Remove-Todo
{
  <#
    .SYNOPSIS
    Deletes a task from the todo.txt file.

    .DESCRIPTION
    Permanently removes a task based on its line number. Rewrites the todo.txt file and reindexes the remaining tasks.

    .PARAMETER LineNumber
    The line number of the task to delete.

    .PARAMETER FilePath
    Optional path override for the main todo.txt file.

    .EXAMPLE
    Remove-Todo -LineNumber 2

    .NOTES
    This function does not archive the deleted task. Use Complete-Todo if you want to archive instead.
    #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [int]$LineNumber,

    [string]$FilePath = (Get-ModuleSetting -Name 'TaskFilePath')
  )

  $tasks = Read-ToDoFile -Path $FilePath
  $taskToRemove = $tasks | Where-Object { $_.LineNumber -eq $LineNumber }

  if (-not $taskToRemove)
  {
    Write-Warning "No task found at line $LineNumber."
    return
  }

  $tasks = $tasks | Where-Object { $_.LineNumber -ne $LineNumber }

  # Re-index line numbers
  $tasks = $tasks | Sort-Object LineNumber
  $index = 1
  foreach ($t in $tasks)
  {
    $t.LineNumber = $index++
  }

  if ($tasks.Count -gt 0)
  {
    Write-TodoFile -Tasks $tasks -Path $FilePath
  } else
  {
    Clear-Content -Path $FilePath
  }

  [PSCustomObject]@{
    Status    = 'Deleted'
    Line      = $LineNumber
    FilePath  = $FilePath
    TaskText  = $taskToRemove.Raw
  }
}

