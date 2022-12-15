# Author: Alexander Sutter
# Date: 12/12/2022
# Latest Update:
# PowerShell: 7.3

<# Description: 
    Writes to host a hash table with an option for recursively. This is an improvement on other ways to write to host hashtables
#>

function Write-Hashtable {
    param (
        # Hashtable to display
        [Parameter(Mandatory)]
        $Table,

        # Option to show any nest hashtables
        [Parameter(Mandatory = $false)]
        [switch]
        $Recurse,

        # Name of Table
        [Parameter(Mandatory = $false)]
        [String]
        $TableName = "",

        # Nested Level
        [Parameter(Mandatory = $false)]
        [int]
        $Level = 1
    ) # end param

    $TabSpace = "    " # Default set to 4 spaces

    # Create Indent
    $Indent = ""
    $BraceIndent = ""
    for ($i=0; $i -lt $Level; $i++) {
        $Indent += $TabSpace
        if ($i -lt ($Level-1)) {
            $BraceIndent += $TabSpace
        } # end if statement
    } # end for $i loop

    # Add Table Name
    if ($TableName -eq "") {
        Write-Host "$($BraceIndent){"
    } # end if statement
    else {
        Write-Host "$($BraceIndent)`"$($TableName)`": {"
    } # end else statement

    # Write Hashtable to host
    foreach ($Key in $Table.Keys) {
        # Nested Hashtable
        if ($Table[$Key].GetType().Name -eq "HashTable" -and $Recurse) {
            Write-Hashtable -Table $Table[$Key] -TableName $Key -Level ($Level + 1) -Recurse
        } # end if statement
        
        # Element is not a basic type and is not a hashtable
        elseif ($Table[$Key].GetType().Name -eq "ADUser" -and $Recurse) {
            $TempTable = @{}
            $Table[$Key].psobject.properties | ForEach-Object { $TempTable[$_.Name] = $_.Value }

            Write-Hashtable -Table $TempTable -TableName $Key -Level ($Level + 1) -Recurse
        } # end elseif statement
        
        # Write Value
        else {
            Write-Host "$($Indent)`"$($Key)`": `"$($Table[$Key])`""
        } # end else statement
    } # end foreach $Key loop

    Write-Host "$($BraceIndent)"
} # end Write-Hashtable

$TestTable = @{
    a = "apple"
    b = @{
        one = "ball"
        two = "bat"
        three = "bring"
    }
    c = "carrot"
    m = @{
        name = "Alex"
        age = 23
        job = @{
            title = "Secuirty Engineer Associate"
            company = "Chubb"
            monthsWorked = 4
            startDate = (Get-Date "07/18/2022")
        } # end job
    } # end m
    z = "Zebra"
} # end TestTable

$Keys = $TestTable.Keys

$Keys

Write-Hashtable $TestTable -Recurse