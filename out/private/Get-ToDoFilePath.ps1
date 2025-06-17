function Get-TodoFilePath
{
  <#
    .SYNOPSIS
    Resolves file paths for todo.txt-related files.
    .DESCRIPTION
    Returns a full path to the specified todo.txt file, respecting module settings or environment variables.
  #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]$FileName
  )

  $baseDir = $env:TODO_DIR
  if (-not $baseDir)
  {
    $baseDir = Join-Path -Path $HOME -ChildPath ".todo"
  }
  if (-not (Test-Path $baseDir))
  {
    New-Item -Path $baseDir -ItemType Directory -Force | Out-Null
  }
  return Join-Path -Path $baseDir -ChildPath $FileName
}
