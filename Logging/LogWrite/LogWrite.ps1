# Author: Alexander Sutter
# Date: 08/26/2022
# Latest Update:
# PowerShell Version: 5.1

# LogWrite

<#
    Basic logging functionality to create and write to a log file
#>

# $LogFile = "Log file path here"
$LogFile = "$($pwd)"
$LogHeader = "Default(date)"

function LogWrite {
    param (
        [String] $Message
    )
    
    Add-Content `
        -Path $LogFile `
        -Encoding Ascii
        -Value $Message
} # end LogWrite

if ( Test-Path($LogFile) ) {
    LogWrite "$(Get-Date)"
} # end if statement
else {
    Add-Content `
        -Path $LogFile `
        -Value $LogHeader
} # end else statement