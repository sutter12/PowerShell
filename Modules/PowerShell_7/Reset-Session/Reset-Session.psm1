# Author: Alexander Sutter
# Date: 08/02/2022
# Latest Update: 09/23/2022
# PowerShell Version: 5.1 & 7

# Reset-Session

<# Description
    Resets the active PowerShell session for PowerShell 5 & 7
#>

function Reset-Session {
    if($PSVersionTable.PSVersion.Major -eq 5) {
        Invoke-Command { & "powershell.exe" } -NoNewScope # PowerShell 5
    } # end if statement
    elseif($PSVersionTable.PSVersion.Major -eq 7) {
        Invoke-Command { & "pwsh" } -NoNewScope # PowerShell 7
    } # end if statement
} # end Reset-Session