# Author: Alexander Sutter
# Date: 12/22/2022
# Latest Update:
# PowerShell Version: 5.1

$ScriptName = "New-Script.ps1"

$NewScriptParams = @{
    Verbose = $true
    Path = "C:\Users\sutte\Documents\GitHub\PowerShell\New-Script\$($ScriptName)"
    Version = "1.0"
    Author = "Alexander Sutter"
    CompanyName = "SutterStudios"
} # end NewScriptParams

New-ScriptFileInfo @NewScriptParams

Test-ScriptFileInfo -Path $NewScriptParams.Path