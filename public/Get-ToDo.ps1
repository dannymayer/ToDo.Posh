function Get-Todo
{
  <#
    .SYNOPSIS
    Retrieves tasks from the todo.txt file with optional filtering.

    .DESCRIPTION
    Lists tasks with support for filtering by priority, project, context, and completion status. Uses Read-ToDoFile internally.

    .PARAMETER Priority
    Filter tasks by single-letter priority (A-Z).

    .PARAMETER Project
    Filter tasks that contain the specified +project tag.

    .PARAMETER Context
    Filter tasks that contain the specified @context tag.

    .PARAMETER Completed
    Return only tasks that are marked complete.

    .PARAMETER Incomplete
    Return only tasks that are not marked complete.

    .EXAMPLE
    Get-Todo -Priority A -Project Work -Incomplete

    .NOTES
    Tasks returned are objects with Raw, LineNumber, CreatedDate, etc.
    #>
  [CmdletBinding(DefaultParameterSetName = 'All')]
  param (
    [ValidatePattern('^[A-Z]$')]
    [string]$Priority,

    [string]$Project,
    [string]$Context,

    [Parameter(ParameterSetName = 'Completed')]
    [switch]$Completed,

    [Parameter(ParameterSetName = 'Incomplete')]
    [switch]$Incomplete,

    [string]$FilePath = (Get-ModuleSetting -Name 'TaskFilePath')
  )

  $tasks = Read-ToDoFile -Path $FilePath

  if ($Priority)
  {
    $tasks = $tasks | Where-Object { $_.Priority -eq $Priority }
  }

  if ($Project)
  {
    $tasks = $tasks | Where-Object { $_.Raw -match "\+$Project(\s|\$)" }
  }

  if ($Context)
  {
    $tasks = $tasks | Where-Object { $_.Raw -match "@$Context(\s|\$)" }
  }

  if ($Completed.IsPresent)
  {
    $tasks = $tasks | Where-Object { $_.Raw -match '^x\s+\d{4}-\d{2}-\d{2}\s' }
  } elseif ($Incomplete.IsPresent)
  {
    $tasks = $tasks | Where-Object { $_.Raw -notmatch '^x\s+\d{4}-\d{2}-\d{2}\s' }
  }

  return $tasks
}

