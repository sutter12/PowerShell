# Author: Alexander Sutter
# Date: 08/29/2022
# Latest Update: 
# PowerShell Version: 5.1

# Add-Module

<# Notes: #>

# Imports

# Mode to run program in
$Mode = "Config"
# $Mode = "Console"
# Path to log file
$Logfile = "C:\Users\sutte\Documents\Github\Personal-PowerShell\Modules\Add-Module.Log"

# Log File Format: Date, Action, Comment
# Function to Log Program Information
function LogWrite {
    param (
        [String] $Message
    )
    
    Add-Content `
        -Path $LogFile `
        -Encoding Ascii
        -Value $Message
} # end LogWrite

function initScript {
    # Write what is actually running
    Write-Host "Start of $($MyInvocation.MyCommand.Name)" -ForegroundColor Cyan
    
    # Output the mode that is being used for this run
    Write-Host "Program Mode -> $($Mode)" -ForegroundColor Yellow

    # Write Header or start script to log file
    if ( Test-Path($LogFile) ) {
        LogWrite "$(Get-Date), Start of $($MyInvocation.MyCommand.Name)"
    } # end if statement
    else {
        $LogHeader = "Date,Action,Comment"
        Add-Content `
            -Path $LogFile `
            -Value $LogHeader
    } # end else statement
} # end initScript

function Add-Module {
    param (
        $Mode
    )
    
    # Initalize Script
    initScript

    if ($Mode -eq "Config") {
        $config = Get-ConfigFile
    } # end if statement

} # end Add-Module

Add-Module -Mode $Mode