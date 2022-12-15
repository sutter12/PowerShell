# Author: Alexander Sutter
# Date: 08/26/2022
# Latest Update: 09/28/2022
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