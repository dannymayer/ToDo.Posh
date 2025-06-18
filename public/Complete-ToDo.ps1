function Complete-Todo
{
  <#
    .SYNOPSIS
    Marks a task as completed in the todo.txt file.

    .DESCRIPTION
    Reads the todo list, marks a specific task as completed, updates the file, and optionally moves the completed task to done.txt based on configuration.

    .PARAMETER LineNumber
    The line number of the task to mark complete.

    .PARAMETER FilePath
    Optional override for the main todo.txt file path.

    .EXAMPLE
    Complete-Todo -LineNumber 3

    .NOTES
    This function prepends today's date and an 'x' to the task to denote completion.
    #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [int]$LineNumber,

    [string]$FilePath = (Get-ModuleSetting -Name 'TaskFilePath')
  )

  $tasks = Read-ToDoFile -Path $FilePath
  $task = $tasks | Where-Object { $_.LineNumber -eq $LineNumber }

  if (-not $task)
  {
    Write-Warning "Task at line $LineNumber not found."
    return
  }

  $completionDate = Get-Date -Format yyyy-MM-dd
  $completedRaw = "x $completionDate $($task.Raw)"
  $task.Raw = $completedRaw

  # Remove any duplicate completion tags if already completed
  $task.Raw = $task.Raw -replace '^x \d{4}-\d{2}-\d{2} x ', 'x '

  $archived = $false
  if (Get-ModuleSetting -Name 'ArchiveOnComplete')
  {
    $donePath = Get-ModuleSetting -Name 'DoneFilePath'
    if (-not (Test-Path $donePath))
    {
      New-Item -ItemType File -Path $donePath -Force | Out-Null
    }
    Add-Content -Path $donePath -Value $task.Raw
    $archived = $true
    $tasks = $tasks | Where-Object { $_.LineNumber -ne $LineNumber }
  }

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
    Status    = 'Completed'
    Task      = $task.Raw
    Line      = $LineNumber
    Archived  = $archived
    FilePath  = $FilePath
  }
}

