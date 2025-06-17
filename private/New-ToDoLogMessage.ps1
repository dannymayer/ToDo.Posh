function New-ToDoLogMessage
{
  <#
    .SYNOPSIS
    Outputs a formatted message to the console.
    .DESCRIPTION
    Displays info, warning, or error messages for internal use.
    #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]$Message,

    [ValidateSet("Info", "Warning", "Error")]
    [string]$Level = 'Info'
  )

  switch ($Level)
  {
    'Info'
    { Write-Host "[INFO] $Message" -ForegroundColor Green 
    }
    'Warning'
    { Write-Warning "$Message" 
    }
    'Error'
    { Write-Error "$Message" 
    }
  }
}

