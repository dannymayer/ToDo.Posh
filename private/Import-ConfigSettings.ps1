function Import-ConfigSettings
{
  <#
    .SYNOPSIS
    Loads ToDoPosh settings from a JSON configuration file.

    .DESCRIPTION
    This function reads a user-defined JSON file containing configuration overrides and applies them at runtime using Set-ModuleSetting.

    .PARAMETER Path
    The path to the JSON settings file. If not specified, defaults to "$env:TODO_DIR\config.json".

    .EXAMPLE
    Load-SettingsFromFile -Path "$HOME\.config\ToDoPosh\config.json"

    .NOTES
    The file should contain a flat key-value object.
    #>
  [CmdletBinding()]
  param (
    [string]$Path = "$env:TODO_DIR\config.json"
  )

  if (-not (Test-Path $Path))
  {
    Write-Warning "Settings file not found at $Path."
    return
  }

  try
  {
    $json = Get-Content -Path $Path -Raw | ConvertFrom-Json

    foreach ($key in $json.PSObject.Properties.Name)
    {
      Set-ModuleSetting -Name $key -Value $json.$key
    }

    Write-Verbose "Loaded settings from $Path"
  } catch
  {
    Write-Error "Failed to load settings from $Path\: $_"
  }
}

