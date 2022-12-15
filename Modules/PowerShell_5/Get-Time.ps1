# Author: Alexander Sutter
# Date: 08/02/2022
# Latest Update:

# Get-Time

# Get current time in hours, minutes, & seconds (ex: 13:20:45)

function Get-Time {
    Get-Date -Format HH:mm:ss
} # end Get-Time