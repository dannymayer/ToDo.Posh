function Get-ModuleSetting
{
  <#
    .SYNOPSIS
    Retrieves a module-level configuration setting.

    .DESCRIPTION
    Provides centralized access to configuration options used across the ToDoPosh module.
    Settings can be stored in memory or later adapted to be pulled from a file or environment variables.

    .PARAMETER Name
    The key of the setting to retrieve. Case-insensitive.

    .OUTPUTS
    System.Object - The value of the setting, or $null if not defined.

    .EXAMPLE
    Get-ModuleSetting -Name 'DateOnAdd'

    .NOTES
    Expand this function to support persistent settings in a JSON or INI config file, or via `$env:`.
    #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]$Name
  )

  # Default in-memory settings
  $settings = @{
    DateOnAdd           = $true         # Automatically prepend creation date to new tasks
    DefaultPriority     = ''            # Empty = no default priority; otherwise use A, B, etc.
    TaskFilePath        = "$env:TODO_DIR\todo.txt"
    DoneFilePath        = "$env:TODO_DIR\done.txt"
    ReportFilePath      = "$env:TODO_DIR\report.txt"
    BackupOnWrite       = $true         # Create .bak copies before saving changes
    ArchiveOnComplete   = $true         # Move completed tasks to done.txt
    UseColorOutput      = $true         # Enable ANSI color output in supported terminals
    AllowEmptyTaskText  = $false        # Disallow empty task bodies
    TrimWhitespace      = $true         # Clean up extra whitespace in task lines
    EnableProjectIndex  = $true         # Enable tagging of +projects and @contexts
  }

  $key = $Name.ToLowerInvariant()
  $match = $settings.Keys | Where-Object { $_.ToLowerInvariant() -eq $key }

  if ($match)
  {
    return $settings[$match]
  } else
  {
    Write-Warning "Unknown setting: $Name"
    return $null
  }
}

