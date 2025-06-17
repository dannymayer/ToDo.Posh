# File: private\Read-TodoFile.ps1
function Read-TodoFile
{
  <#
    .SYNOPSIS
    Reads all lines from a todo.txt-related file.
    .DESCRIPTION
    Returns the file contents as an array of strings.
    #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]$Path
  )

  if (Test-Path $Path)
  {
    return Get-Content -Path $Path -Raw | Out-String | ConvertFrom-StringData -Delimiter "`n"
  } else
  {
    return @()
  }
}
