# Author: Alexander Sutter
# Date: 12/31/2022
# Latest Update:
# PowerShell Version: 5.1

# winget Upgrade

$Upgrades = winget upgrade

$ObjectTable = @{}

# Convert Upgrades Object to HashTable
$Upgrades.psobject.Properties | ForEach-Object { $ObjectTable[$_.Name] = $_.Value }

# Necessary info in SyncRoot of HashTable while discarding first 2 and last 2 elements of array as they are blanks and Extra Info
$UpgradeTable = $ObjectTable["SyncRoot"][2..($ObjectTable["SyncRoot"].Length)]

$NameIndex = $UpgradeTable[0].IndexOf("Name")
$IDIndex = $UpgradeTable[0].IndexOf("Id")
$VersionIndex = $UpgradeTable[0].IndexOf("Version")
$AvailableIndex = $UpgradeTable[0].IndexOf("Available")
$SourceIndex = $UpgradeTable[0].IndexOf("Source")

# Get Number of upgrades available
if ($UpgradeTable[$UpgradeTable.Length-1].Contains("upgrades available")) {
    $UpgradesAvailable = $UpgradeTable[$UpgradeTable.Length-1]
    $EndCut = 2
} # end if statement

$Applications = $UpgradeTable[2..($UpgradeTable.Length-$EndCut)]

Write-Host "Welcome to the winget upgrader tool you have " -NoNewline
Write-Host $UpgradesAvailable -ForegroundColor Magenta
foreach ($Application in $Applications) {
    # Derive Application Info
    $ApplicationName = $Application.Substring($NameIndex, $IDIndex - $NameIndex)
    $ApplicationID = $Application.Substring($IDIndex, $VersionIndex - $IDIndex)
    $ApplicationID = $ApplicationID.SubString(0, $ApplicationID.IndexOf("  "))
    $ApplicationVersion = $Application.Substring($VersionIndex, $AvailableIndex - $VersionIndex)
    $ApplicationAvailable = $Application.Substring($AvailableIndex, $SourceIndex - $AvailableIndex)
    $ApplicationSource = $Application.Substring($SourceIndex, $Application.Length - $SourceIndex)
    
    # testing if 
    # if ($ApplicationName -ne "LogMeIn Hamachi                           ") {
    #     Write-Host $ApplicationName
    #     Set-Clipboard $ApplicationName
    #     # Read-Host "Press Enter"
    #     continue
    # } # end if statement
    # else {
    #     Write-Host "App Found"
    # }

    if ($ApplicationSource -eq "winget") {
        # Display Application Available for update
        Write-Host $ApplicationName -ForegroundColor Yellow -NoNewline
        Write-Host " has an update from " -NoNewline
        Write-Host $ApplicationVersion -ForegroundColor Yellow -NoNewline
        Write-Host " to " -NoNewline
        Write-Host $ApplicationAvailable -ForegroundColor Green

        $UserInput = Read-Host "Would you like to upgrade?`nYes[y]   Skip[s]  No[n]"

        if ($UserInput -eq "y" -or $UserInput -eq "Y") {
            Write-Host "Upgrading $($ApplicationName)"

            winget upgrade $ApplicationID
        } # end if statement
        elseif ($UserInput -eq "s" -or $UserInput -eq "S") {
            Write-Host "Skipping Upgrade"
        } # end elseif statement

        Write-Host "`"$($ApplicationID)`""
    } # end if statement
    else {
        Write-Host "Error: winget is not the source of the application $($Application)"
        throw "Unknown Source"
    } # end else statement
    
} # end foreach $Application loop
# $UpgradeTable[18].SubString($IDIndex, $VersionIndex - $IDIndex)
