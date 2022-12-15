# Author: Alexander Sutter
# Date: 09/16/2022
# Latest Update:
# PowerShell Version: 5.1

# Testing Leveled LogWrite

# Imports
Using module Logging

<# Notes:

#>

$Log = [Logging]::new()

$Log.debug("Debug Log Write")
$Log.info("Info Log Write")
$Log.warning("Warning Log Write")
$Log.error("Error Log Write")
$Log.critical("Critical Log Write")

$Log.BasicConfig("INFO", "test.log", "w")

$Log.debug("Debug Log Write")
$Log.info("Info Log Write")
$Log.warning("Warning Log Write")
$Log.error("Error Log Write")
$Log.critical("Critical Log Write")