# Author: Alexander Sutter
# Created: 06/10/2023
# PowerShell Version: 5.1

$ScreenshotsPath = "E:\Pictures\Screenshots"

function Get-FileExtension {
    param (
        # FileName with file extension
        [Parameter(Mandatory)]
        [String]
        $FileName
    ) # end param

    # Write-Host $FileName.IndexOf('.')

    return $FileName.Substring(($FileName.IndexOf('.') + 1), ($FileName.Length - $FileName.IndexOf('.') - 1))

    # return $FileName.SubString(($File.Name.Length-4),4)
    
} # end Get-FileExtension

$Screenshots = Get-ChildItem $ScreenshotsPath
foreach ($File in $Screenshots) {
    if ($File.Name -like "Screenshot*") {
        Write-Host "`nFile = $($File.VersionInfo.FileName)"
        # Write-Host "File.CreationTime = $(Get-Date "$($File.CreationTime)")"
        Write-Host "File.LastWriteTime = $(Get-Date "$($File.LastWriteTime)")"
        
        $FileExtension = Get-FileExtension -FileName $File.Name
        Write-Host "FileExtension = $($FileExtension)"

        $CreationTimeStamp = Get-Date "$($File.LastWriteTime)" -Format "yyyy-MM-dd HHmmss"

        $NewFileName = "Screenshot $($CreationTimeStamp).$($FileExtension)"
        Write-Host "NewFileName = $($NewFileName)" -ForegroundColor Green

        Rename-Item -Path $File.VersionInfo.FileName -NewName $NewFileName -Confirm:$true
        
        # $File | Fl
    } # end if statement
    # break
} # end foreach $File loop