function Set-ModuleSetting
{
  <#
    .SYNOPSIS
    Sets or overrides a module-level configuration value.

    .DESCRIPTION
    Allows customization of ToDoPosh behavior by setting runtime settings. These may later be saved to a config file for persistence across sessions.

    .PARAMETER Name
    The name of the setting to modify.

    .PARAMETER Value
    The value to assign to the specified setting.

    .EXAMPLE
    Set-ModuleSetting -Name 'DateOnAdd' -Value $false

    .NOTES
    Persistent storage (e.g., config file) is not implemented yet, but planned.
    #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]$Name,

    [Parameter(Mandatory)]
    [object]$Value
  )

  # Use script scope to persist across module sessions
  if (-not $script:ToDoSettings)
  {
    $script:ToDoSettings = @{}
  }

  $script:ToDoSettings[$Name] = $Value
  Write-Verbose "Set setting [$Name] = $Value"
  return $true
}
