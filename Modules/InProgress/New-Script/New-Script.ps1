
<#PSScriptInfo

.VERSION 1.0

.GUID 5cd9f782-e799-4f48-9b10-9d095d32ba93

.AUTHOR Alexander Sutter

.COMPANYNAME SutterStudios

.COPYRIGHT 

.TAGS 

.LICENSEURI 

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


#>

<# 

.DESCRIPTION 
 Creates a new script file with metadata 

#> 
Param(
    # Location for New Script
    [Parameter(Mandatory = $false)]
    [String]
    $ScriptPath = "",

    # Name of New Script
    [Parameter(Mandatory = $false)]
    [String]
    $ScriptName = "",

    # Description of New Sciprt
    [Parameter(Mandatory = $false)]
    [String]
    $ScriptDescription = ""
)

# Get Script Location if not already set
if ($ScriptPath -eq "") {
    $ScriptPath = Read-Host -Prompt "Location of New Script"
} # end if statement

# Get Script Name if not already set
if ($ScriptName -eq "") {
    $ScriptName = Read-Host -Prompt "Name of New Script(include extension)"
} # end if statement

# Get Script Description if not already set
if ($ScriptDescription -eq "") {
    $ScriptDescription = Read-Host -Prompt "Description of Script"
} # end if statement

$NewScriptParams = @{
    Verbose = $true
    Path = "$($ScriptPath)\$($ScriptName)"
    Description = $ScriptDescription
    Version = "1.0"
    Author = "Alexander Sutter"
    CompanyName = "SutterStudios"
} # end NewScriptParams

New-ScriptFileInfo @NewScriptParams

Test-ScriptFileInfo -Path $NewScriptParams.Path