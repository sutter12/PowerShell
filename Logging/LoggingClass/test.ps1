# $path = "C:\Users\sutte\Documents\Test\Test1\Test2\test.txt"
# Write-Host "Path -> $($path)" -ForegroundColor Green

# $LocationForLog = $path.Substring(0, ($path.LastIndexOf("\") ) )

# $DirectoriesToCreate = @()
# while (-Not (Test-Path $LocationForLog) ) {
#     $LastSlash = $LocationForLog.LastIndexOf("\")

#     $DirectoriesToCreate += $LocationForLog.Substring(($LastSlash + 1))
#     Write-Host $DirectoriesToCreate

#     $LocationForLog = $LocationForLog.Substring(0, $LastSlash)
#     Write-Host "New Location for log -> $($LocationForLog)"
# } # end while loop

# Write-Host "Length of Directories to create -> $($DirectoriesToCreate.Length)"

# Write-Host "Location for Logging -> $($LocationForLog)" -ForegroundColor Red

# for ($i=$DirectoriesToCreate.Length-1; $i -ge 0; $i--) {
#     Write-Host "Creating -> `'$($DirectoriesToCreate[$i])`'" -ForegroundColor Yellow
#     Write-Host "At -> $($LocationForLog)" -ForegroundColor Yellow
#     New-Item `
#         -Path $LocationForLog `
#         -Name $DirectoriesToCreate[$i] `
#         -ItemType Directory
#     $LocationForLog += "\" + $DirectoriesToCreate[$i]
# } # end for $i loop


# Did not work 
# $path = "C:\Users\sutte\Documents\Programming\GitHub\Personal-PowerShell\Logging\Leveled LogWrite\Test\test\testLog.log"
# Add-Content -Path $path -Value "Hi" -Encoding Ascii

# Queue's
$DirectoriesToCreate = New-Object System.Collections.Queue

$DirectoriesToCreate.Enqueue(1)
$DirectoriesToCreate.Enqueue(2)
$DirectoriesToCreate.Enqueue(3)
$DirectoriesToCreate.Enqueue(4)
$DirectoriesToCreate.Enqueue(5)

Write-Host $DirectoriesToCreate