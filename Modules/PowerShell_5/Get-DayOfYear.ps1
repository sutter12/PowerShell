# Author: Alexander Sutter
# Date: 08/26/2022
# Latest Update: 
# PowerShell Version: 5.1

# Get-DayOfYear

<#
    Gets the day of the year that the current day is
    ex: Jan. 2 would return 2 as the 2nd day of the year
#>

function Get-DayOfYear {
    (Get-Date).DayOfYear
} # end Get-DayOfYear
