#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path $PSScriptRoot\public\* -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\private\* -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($import in @($Public + $Private))
{
  Try
  {
    . $import.fullname
  } Catch
  {
    Write-Error -Message "Failed to import function $($import.fullname): $_"
  }
}

Export-ModuleMember -Function $Public.BaseName
