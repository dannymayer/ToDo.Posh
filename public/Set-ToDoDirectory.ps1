function Set-TodoDirectory
{
  <#
    .SYNOPSIS
    Sets the TODO_DIR environment variable and ensures the directory exists.

    .DESCRIPTION
    This helper function sets the TODO_DIR environment variable both in the current session and persistently for the current user. It also ensures the directory exists, creating it if necessary.

    .PARAMETER Path
    The path to set as TODO_DIR.

    .EXAMPLE
    Set-TodoDirectory -Path "$HOME\.todo"

    .NOTES
    Future roadmap: synchronize with config settings dynamically.
    #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string]$Path
  )

  if (-not (Test-Path $Path))
  {
    try
    {
      New-Item -ItemType Directory -Path $Path -Force | Out-Null
      Write-Host "Created directory: $Path"
    } catch
    {
      Write-Error "Failed to create directory: $_"
      return
    }
  }

  try
  {
    [System.Environment]::SetEnvironmentVariable("TODO_DIR", $Path, [System.EnvironmentVariableTarget]::User)
    $env:TODO_DIR = $Path
    Write-Host "`$env:TODO_DIR set to '$Path' (persisted for user)" -ForegroundColor Green
  } catch
  {
    Write-Error "Failed to set environment variable: $_"
  }
}

