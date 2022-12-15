# Logging README

## Examples

### Simple

``` powershell
Using module Logging

$Log = [Logging]::new() # Create the object

$Log.warning("Warning Log Write") # will print a message to the console
$Log.info("Info Log Write") # will not print anything
```

### Logging to a file

``` powershell
Using module Logging

$Log = [Logging]::new() # Create the object

$Log.BasicConfig("INFO", "main.log", "append") # Configure with LEVEL, File, Filemode

$Log.info("This message will go to the Log File")
$Log.warning("Just like this one")
$Log.debug("Not this one though")
$Log.error("However, this will go!")
```

## Levels

| Level | When it's used | Value |
|-------|----------------|-------|
| CRITICAL | A serious error, indicating that the program itself may be unable to continue running. | 50 |
| ERROR | Due to a more serious problem, the software has not been able to perform some function. | 40 |
| WARNING | An indication that something unexpected happened, or indicative of some problem in the near future (e.g. ‘disk space low’). The software is still working as expected. | 30 |
| INFO | Confirmation that things are working as expected. | 20 |
| DEBUG | Detailed information, typically of interest only when diagnosing problems. | 10 |
| NOTSET | Only in creating custom Logging Levels | 0 |

## Errors
