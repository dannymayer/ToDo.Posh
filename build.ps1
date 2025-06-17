<#!
.SYNOPSIS
Build script to validate, clean, and import the ToDo.Posh module for testing.
.DESCRIPTION
This script prepares the module for local testing by:
- Cleaning and recreating the output module directory
- Rebuilding the module by copying all public/private functions
- Dynamically updating the manifest with public function exports
- Importing the module into the current session
#>

# Parameters
$ModuleRoot = "$PSScriptRoot"
$OutputDir  = "$ModuleRoot\out"
$ModuleName = "ToDoPosh"
$ManifestIn = "$ModuleRoot\$ModuleName.psd1"
$ManifestOut = "$OutputDir\$ModuleName.psd1"

# Ensure clean output folder
if (Test-Path $OutputDir)
{
  Remove-Item -Recurse -Force -Path $OutputDir
}
New-Item -ItemType Directory -Path $OutputDir | Out-Null

# Copy psm1
Copy-Item -Path "$ModuleRoot\$ModuleName.psm1" -Destination "$OutputDir\$ModuleName.psm1"

# Copy function scripts
New-Item -ItemType Directory -Path "$OutputDir\public" | Out-Null
New-Item -ItemType Directory -Path "$OutputDir\private" | Out-Null
Copy-Item -Path "$ModuleRoot\public\*.ps1" -Destination "$OutputDir\public" -Recurse
Copy-Item -Path "$ModuleRoot\private\*.ps1" -Destination "$OutputDir\private" -Recurse

# Discover exported function names
$exportedFunctions = Get-ChildItem "$ModuleRoot\public" -Filter *.ps1 | Select-Object -ExpandProperty BaseName

# Read manifest and patch FunctionsToExport block
$manifestLines = Get-Content -Path $ManifestIn

# Locate FunctionsToExport block
$startIndex = -1
$endIndex = -1

for ($i = 0; $i -lt $manifestLines.Count; $i++)
{
  if ($manifestLines[$i] -match '^\s*FunctionsToExport\s*=\s*@\(\s*\)\s*$')
  {
    # Single-line empty block: replace entire line
    $startIndex = $i
    $endIndex = $i
    break
  } elseif ($manifestLines[$i] -match '^\s*FunctionsToExport\s*=\s*@\(\s*$')
  {
    # Multi-line block start
    $startIndex = $i
    for ($j = $i + 1; $j -lt $manifestLines.Count; $j++)
    {
      if ($manifestLines[$j] -match '^\s*\)\s*$')
      {
        $endIndex = $j
        break
      }
    }
    break
  }
}

if ($startIndex -ge 0 -and $endIndex -ge $startIndex)
{
  $replacementBlock = @("    FunctionsToExport = @(")
  foreach ($fn in $exportedFunctions)
  {
    $replacementBlock += "        '$fn'"
  }
  $replacementBlock += "    )"

  $manifestLines = $manifestLines[0..($startIndex - 1)] + $replacementBlock + $manifestLines[($endIndex + 1)..($manifestLines.Count - 1)]
} else
{
  Write-Warning "FunctionsToExport block not found in manifest."
}

# Write patched manifest
Set-Content -Path $ManifestOut -Value $manifestLines -Encoding UTF8

# Import module into current session
if (Get-Module -Name $ModuleName)
{
  Remove-Module -Name $ModuleName -Force
}
Import-Module "$ManifestOut" -Force -Verbose

Write-Host "[$ModuleName] module built and imported successfully from $OutputDir" -ForegroundColor Cyan

