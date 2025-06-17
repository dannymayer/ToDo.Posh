function Write-TodoFile
{
  <#
    .SYNOPSIS
    Writes an array of strings to a todo.txt file.
    .DESCRIPTION
    Replaces the entire content of the file with the provided lines.
    #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]$Path,

    [Parameter(Mandatory)]
    [string[]]$Lines
  )

  Set-Content -Path $Path -Value $Lines -Encoding UTF8
}

