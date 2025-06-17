function Confirm-TodoTask
{
  <#
    .SYNOPSIS
    Validates a todo task object.
    .DESCRIPTION
    Checks if the task object contains required fields like Raw text.
    #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [PSCustomObject]$Task
  )

  return ($Task.Raw -and $Task.Raw.Trim().Length -gt 0)
}
