function Write-TodoFile
{
  <#
    .SYNOPSIS
    Writes the given task list back to the todo.txt file.

    .DESCRIPTION
    Accepts an array of task strings or objects, sorts and writes them to the configured file path. Supports automatic backup of the previous file.

    .PARAMETER Tasks
    An array of either task strings or task objects with a Raw property.

    .PARAMETER Path
    Optional path override for the todo.txt file.

    .EXAMPLE
    $tasks = Read-TodoFile
    $tasks[0].Raw = "Updated task"
    Write-TodoFile -Tasks $tasks

    .NOTES
    Honors the BackupOnWrite setting before writing.
    #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [object[]]$Tasks,

    [string]$Path = (Get-ModuleSetting -Name 'TaskFilePath')
  )

  if (-not $Tasks)
  {
    Write-Warning "No tasks to write. Aborting."
    return
  }

  if (-not (Test-Path $Path))
  {
    New-Item -ItemType File -Path $Path -Force | Out-Null
  }

  if (Get-ModuleSetting -Name 'BackupOnWrite')
  {
    $backupPath = "$Path.bak"
    Copy-Item -Path $Path -Destination $backupPath -Force
    Write-Verbose "Backed up existing file to $backupPath"
  }

  try
  {
    $lines = @()
    foreach ($task in $Tasks)
    {
      if ($task -is [string])
      {
        $lines += $task
      } elseif ($task.PSObject.Properties.Match("Raw"))
      {
        $lines += $task.Raw
      } else
      {
        throw "Task input must be a string or an object with a 'Raw' property."
      }
    }

    Set-Content -Path $Path -Value $lines -Encoding UTF8
    Write-Host "Successfully wrote $($lines.Count) task(s) to $Path" -ForegroundColor Green
  } catch
  {
    Write-Error "Failed to write tasks to file: $_"
  }
}

