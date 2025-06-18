function Initialize-TodoConfig
{
  <#
    .SYNOPSIS
    Creates a default configuration file for the ToDoPosh module.

    .DESCRIPTION
    Writes a template JSON config file to the specified path or to the default path ($env:TODO_DIR\config.json).
    Useful for first-time setup or resetting settings to default.

    .PARAMETER Path
    The path where the config file will be saved.

    .EXAMPLE
    Initialize-TodoConfig -Path "$HOME/.config/ToDoPosh/config.json"

    .NOTES
    Will not overwrite existing files unless -Force is used.
    #>
  [CmdletBinding()]
  param (
    [string]$Path = "$env:TODO_DIR\config.json",

    [switch]$Force
  )

  if (-not (Test-Path (Split-Path -Path $Path)))
  {
    New-Item -ItemType Directory -Path (Split-Path -Path $Path) -Force | Out-Null
  }

  if ((Test-Path $Path) -and -not $Force)
  {
    Write-Warning "Configuration file already exists. Use -Force to overwrite."
    return
  }

  $defaultSettings = @{
    DateOnAdd           = $true
    DefaultPriority     = ''
    TaskFilePath        = "$env:TODO_DIR\todo.txt"
    DoneFilePath        = "$env:TODO_DIR\done.txt"
    ReportFilePath      = "$env:TODO_DIR\report.txt"
    BackupOnWrite       = $true
    ArchiveOnComplete   = $true
    UseColorOutput      = $true
    AllowEmptyTaskText  = $false
    TrimWhitespace      = $true
    EnableProjectIndex  = $true
  }

  try
  {
    $defaultSettings | ConvertTo-Json -Depth 2 | Set-Content -Path $Path -Encoding UTF8
    Write-Host "Default configuration file created at: $Path" -ForegroundColor Green
  } catch
  {
    Write-Error "Failed to create configuration file: $_"
  }
}

