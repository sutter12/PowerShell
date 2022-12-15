# How to Create Scipt Modules

## Author: Alexander Sutter

## Source

[SourceLink] <https://docs.microsoft.com/en-us/powershell/scripting/learn/ps101/10-script-modules?view=powershell-5.1>

## Notes

Run to determine if functions are loaded into memory by checking to see if they exist

```powershell
Get-ChildItem -Path Function:\Get-MrPSVersion
```

## Steps

- Create a function and save it as Verb-Noun.ps1 (ex: Get-MrPSVersion.ps1)

- Navigate to folder in powershell containing your .ps1 file

- Run to load function inside file into memory

```powershell
$. .\Get-MrPSVersion.ps1
```

-or- use fully qualified path

```powershell
$. C:\Demo\Get-MrPSVersion.ps1
```

- Check if function exists
    $Get-ChildItem -Path Function:\Get-MrPSVersion

- Save as with same file name but with .psm1

- Run to check locations of autoloading for scripts

```powershell
$env:PSModulePath -split ';'
```

Now pick a folder and put .psm1 in it

- Create Module Manifest

```powershell
$New-ModuleManifest `
    -Path 'C:\ProgramFiles\WindowsPowerShell\Modules\MyScriptModule\MyScriptModule.psd1' `
    -RootModule MySriptModule `
    -Author 'Alexander Sutter' `
    -Description 'Description of module' `
    -CompanyName 'SutterStudios.com'
```

- Check Manifest
    Run to make sure version is not 0.0

```powershell
$Get-Command -Name MyScriptModule
```
