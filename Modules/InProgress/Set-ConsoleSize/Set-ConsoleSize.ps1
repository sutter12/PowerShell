
<#PSScriptInfo

.VERSION 1.0

.GUID 52f4465f-6d12-40d7-aa39-64ed9856173e

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
 Sets/changes the size of the console 

#> 

[CmdletBinding()]
Param(
    # Height of Console to set
    [Parameter(Mandatory = $false)]
    [int]
    $Height,

    # Width of console to set
    [Parameter(Mandatory = $false)]
    [int]
    $Width,

    # General size of console - predetermined values for height and width
    [Parameter(Mandatory = $false)]
    [ValidateSet("Alex", "Small", "Medium", "Large", "Short", "Tall", "Thin", "Wide", "Default")]
    [String]
    $Size
) # end param

# Set $Height and $Width based on Size
switch ($Size) {
    "Alex" {
        $Height = 65
        $Width = 225
    }
    "Small" {
        $Height = 65
        $Width = 225
    }
    "Medium" {
        $Height = 65
        $Width = 225
    }
    "Large" {
        $Height = 65
        $Width = 225
    }
    "Short" {
        $Height = 65
        $Width = 225
    }
    "Tall" {
        $Height = 65
        $Width = 225
    }
    "Thin" {
        $Height = 65
        $Width = 225
    }
    "Wide" {
        $Height = 65
        $Width = 225
    }
    Default {
        $Height = 50
        $Width = 120
    }
} # end Switch $Size

$Console = $Host.UI.RawUI
$ConsoleBuffer = $Console.BufferSize
$ConsoleSize = $Console.WindowSize

$CurrentHeight = $ConsoleSize.Height
$CurrentWidth = $ConsoleSize.Width

# if height is too large, set to max allowed size
if ($Height -gt $Console.MaxPhysicalWindowSize.Height) {
    $Height = $Console.MaxPhysicalWindowSize.Height
    Write-Warning "Height too large. Set to max allowed size of $($Height)"
} # end if statement

# if width is too large, set to max allowed size
if ($Width -gt $Console.MaxPhysicalWindowSize.Width) {
    $Width = $Console.MaxPhysicalWindowSize.Width
    Write-Warning "Width too large. Set to max allowed size of $($Width)"
} # end if statement

# if the Buffer is higher than the new console setting, first reduce the height
if ($ConsoleBuffer.Height -gt $Height) {
    $CurrentHeight = $Height
} # end if statement

# if the Buffer is wider than the new console setting, first reduce the width
if ($ConsoleBuffer.Width -gt $Width) {
    $CurrentWidth = $Width
} # end if statement

# initial resizing if needed 
$Console.WindowSize = New-Object System.Management.Automation.Host.Size($CurrentWidth, $CurrentHeight)

# Set the Buffer
$Console.BufferSize = New-Object System.Management.Automation.Host.Size($Width, 2000)

# Now set the WindowSize
$Console.WindowSize = New-Object System.Management.Automation.Host.Size($Width, $Height)

Write-Verbose "Height set to: $($Host.UI.RawUI.WindowSize.Height)"
Write-Verbose "Width set to: $($Host.UI.RawUI.WindowSize.Width)"