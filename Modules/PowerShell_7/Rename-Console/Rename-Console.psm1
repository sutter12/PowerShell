# Author: Alexander Sutter
# Date: 12/12/2022
# Latest Update: 
# PowerShell Version: 5.1

# Rename-Console

<# Description:
    Renames the title of the console to the string passed
#>

function Rename-Console {
    param (
        # String to Title the console
        [Parameter(Mandatory)]
        [String]
        $Title
    )
    
    $host.UI.RawUI.WindowTitle = $Title
    
} # end Rename-Console