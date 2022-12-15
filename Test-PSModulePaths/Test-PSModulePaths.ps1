# Author: Alexander Sutter
# Date: 09/29/2022
# Latest Update:
# PowerShell Version: 5.1

# Test-PSModulePaths

<# Description: 
    Test-PSModulePaths is a library of functions to deal with the PSModulePaths.
    There is 
        1. Get-PSModulePaths
        2. Test-PSModulePaths
        3. Initialize-PSModulePaths
        4. Initialize-Path
#>

<# Get-PSModulePaths
    Gets the paths that PowerShell looks in for modules on 
    start up of session and prints them to the console.

    When -NoWrite is provided the function returns an array
    of the PowerShell Module Paths
#>
function Get-PSModulePaths {
    param (
        # Option to not write Module Paths to host and return an array of paths
        [Parameter(Mandatory = $false)]
        [ValidateSet($true, $false)]
        [switch]
        $NoWrite
    ) # end param

    if ($NoWrite) {
        # Get PowerShell Environment Module Paths (PSModulePath)
        $Paths = $env:PSModulePath -split ";"
        
        return $Paths
    } # end if statement
    else {
        $env:PSModulePath -split ";"
    } # end else statement
} # end Get-PSModulePaths

<# Test-PSModulePaths
    Uses Get-PSModulePaths to get all the paths and then
    tests each path to see if it exists and writes to host 
    each path in green if it exists and red if it doesn't
#>
function Test-PSModulePaths {
    # Get PowerShell Environment PSModulePaths
    # $EnvironmentPaths = $env:PSModulePath -split ";"
    $EnvironmentPaths = Get-PSModulePaths -NoWrite

    # Test each module path in the enironment and see if each exists
    foreach ($Location in $EnvironmentPaths) {
        if (Test-Path $Location) {
            Write-Host "Module Path Exists ($($Location))" -ForegroundColor Green
        } # end if statement
        else {
            Write-Host "Module Path Does Not Exist ($($Location))" -ForegroundColor Red
        } # end else statement
    } # end foreach $Location loop
} # end Test-PSModulePaths

function Initialize-PSModulePaths {
    param (
        # PS Module Path to initialize from environment
        [Parameter(Mandatory = $false)]
        [String]
        $Path = "",

        # Parameter help description
        [Parameter(Mandatory = $false)]
        [Switch]
        $All, # if pass $All = $true

        # Debug Mode
        [Parameter(Mandatory = $false)]
        [switch]
        $DebugMode
    ) # end param

    # Get PowerShell Environment Module Paths
    if ($Path -ne "") {
        if ($DebugMode) {
            Write-Host "$($Path)"
        } # end if statement

        # Get all environment paths
        $EnvironmentPaths = Get-PSModulePaths -NoWrite

        # Check if $Path is recognized in the environment
        if ($Path -in $EnvironmentPaths) {
            Write-Host "Valid Path"

            # Create Path
            if ($DebugMode) {
                Initialize-Path -Path $Path -DebugMode    
            } # end if statement
            else {
                Initialize-Path -Path $Path
            } # end else statement
        } # end if statement
        else {
            Write-Host "Path is not in PSModulePaths" -ForegroundColor Red
            throw
        } # end else statement
    } # end if statement
    elseif ($All) {
        # Get all environment paths
        $EnvironmentPaths = Get-PSModulePaths -NoWrite

        foreach ($Path in $EnvironmentPaths) {
            if (Test-Path $Path) {
                Write-Host "Path Exists: $($Path)" -ForegroundColor Green
            } # end if statement
            else {
                Write-Host "Creating Path: $($Path)" -ForegroundColor Yellow

                if ($DebugMode) {
                    Initialize-Path `
                        -DebugMode `
                        -Path $Path
                } # end if statement
                else {
                    Initialize-Path `
                        -Path $Path
                } # end else statement
            } # end else statement
        } # end foreach $Path loop

    } # end elseif statement
    else {
        Write-Host "Either pass a path to -Path or pass -all" -ForegroundColor Red
    } # end else statement
    
} # end Initialize-PSModulePaths

function Initialize-Path {
    # [CmdletBinding()]
    param (
        # Path to initialize
        [Parameter(Mandatory)]
        [String]
        $Path, 

        # DebugMode
        [Parameter(Mandatory = $false)]
        [switch]
        $DebugMode
    ) # end param

    # Determine the slash used for path
    if ($Path.Contains('\')) {
        $PathSlash = "\"
    } # end if statement
    elseif ($Path.Contains("/")) {
        $PathSlash = "/"
    } # end elseif statement
    if ($DebugMode) {
        Write-Host "Slash used -> $($PathSlash)" -ForegroundColor Magenta
    } # end if statement

    # Determine confirmed path and directories to create to complete the path
    $ConfirmedPath = $Path
    $DirectoriesToCreate = @()
    while (-Not (Test-Path $ConfirmedPath)) {
        $LastSlash = $ConfirmedPath.LastIndexOf($PathSlash)

        $DirectoriesToCreate += $ConfirmedPath.Substring(($LastSlash + 1))

        $ConfirmedPath = $ConfirmedPath.Substring(0, $LastSlash)
        if ($DebugMode) {
            Write-Host "DirectoriesToCreate -> $($DirectoriesToCreate)" -ForegroundColor Magenta
            Write-Host "ConfimredPath so far -> $($ConfirmedPath)" -ForegroundColor Magenta
        } # end if statement
    } # end while loop

    # DirectoryiesToCreate is backwards so you have to add them backwards
    # Write-Host $DirectoriesToCreate[$DirectoriesToCreate.Length - 1]
    for ($i=$DirectoriesToCreate.Length-1; $i -gt (-1); $i--) {
        if ($DebugMode) {
            Write-Host $DirectoriesToCreate[$i]
        } # end if statement

        # Create Directory
        if ($DebugMode) {
            New-Item `
                -WhatIf `
                -Path $ConfirmedPath `
                -Name $DirectoriesToCreate[$i] `
                -ItemType Directory
        } # end if statement
        else {
            New-Item `
                -Path $ConfirmedPath `
                -Name $DirectoriesToCreate[$i] `
                -ItemType Directory
        } # end else statement

        # Add New Directory to confirmed Path and test
        $ConfirmedPath += $PathSlash + $DirectoriesToCreate[$i]
        
        if (Test-Path $ConfirmedPath) {
            Write-Host "New Path Confirmed" -ForegroundColor Green
        } # end if statement
        else {
            if ($DebugMode) {
                Write-Host "New Addition to path doesn't exist" -ForegroundColor Red
            } # end if statement
            else {
                throw "New Addition to path doesn't exist"
            } # end else statement
        } # end else statement
    } # end for $i loop
} # end Initialize-Path