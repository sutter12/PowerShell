# Author: Alexander Sutter
# Date: 08/26/2022
# Latest Update: 09/28/2022
# PowerShell Version: 5.1

# Leveled Logging

<# Description:
    All the functionality of LogWrite which helps to create and write to
    a log file. This version has added multi leveled logs similar to other
    languages built in log capabilites
#>

<# Logging levels and their applicability
    Levels,     When it's used
    DEBUG,      Detailed information, typically of interest only when diagnosing problems.
    INFO,       Confirmation that things are working as expected.
    WARNING,    An indication that something unexpected happened, or indicative of some problem in 
                the near future (e.g. ‘disk space low’). The software is still working as expected.
    ERROR,      Due to a more serious problem, the software has not been able to perform some function.
    CRITICAL,   A serious error, indicating that the program itself may be unable to continue running.
#>

class Logging {
    # [bool] $DebugMode = $false # Default
    [bool] $DebugMode = $true # Testing

    [ValidateNotNullOrEmpty()][String] $Filename
    [String] $Path

    [String] $strLevel
    [int] $intLevel

    [String] $Encoding
    [String] $FileMode
    [String] $LogFormat
    [String] $DateFormat
    [String] $LogHeader
    [String] $Delimiter
    
    $Level = @{
        CRITICAL = 50
        ERROR = 40
        WARNING = 30
        INFO = 20
        DEBUG = 10
        NOTSET = 0
    } # end $Level

    #Constructor
    Logging() {
        $this.Path = ""

        $this.strLevel = "WARNING" # Default
        $this.SetLevel($this.strLevel)

        $this.Delimiter = ":"
        $this.Encoding = "utf-8"
        $this.FileMode = "Append" # Default
        $this.LogFormat = "level" + $this.Delimiter + "date" # Default
        $this.DateFormat = "MMMM dd, yyyy hh:mm:ss" # Default
        $this.LogHeader = $this.LogFormat + $this.Delimiter + "message"
    } # end constructor

    <# BasicConfig
        Sets the Level
        Log file
        Filemode
    #>
    [void] BasicConfig([String]$newLevel, [String]$newFilename, [String]$newFileMode) {
        # Check and confirm level
        if ($this.Level.ContainsKey($newLevel)) {
            $this.SetLevel($newLevel)
        } # end if statement
        else {
            Throw "Level -> $($newLevel) is not understood"
        } # end else statement
        
        # Check and enforce filemode here
        $newFileMode = $newFileMode.ToLower()
        switch ($newFileMode) {
            "a" {
                $this.FileMode = "Append"
            } # end "a"
            "append" {
                $this.FileMode = "Append"
            } # end "append"
            "w" {
                $this.FileMode = "Write"
            } # end "w"
            "write" {
                $this.FileMode = "Write"
            } # end "write"
            Default {
                Write-Host "Error: Filemode `'$($newFileMode)`' is not recognized. Setting filemode to default"
                $this.FileMode = "Append"
            } # end default
        } # end switch statement

        <# Check filename: Accepting filename, filename with extension, full path or relative path #>
        # Check and use full path
        if ($newFilename.Contains('\') -or $newFilename.Contains("/")) {
            # new filename is actually a path
            
            if ($newFilename.Contains('\')) {
                $PathSlash = "\"
            } # end if statement
            elseif ($newFilename.Contains("/")) {
                $PathSlash = "/"
            } # end elseif statement
            else {
                Throw "Code Broken: something went wrong in dealing with the / or \ in BasicConfig().newFilename"
            } # end else statement

            $LocationForLog = $newFilename.Substring(0, ($newFilename.LastIndexOf($PathSlash)) )
            if (Test-Path $LocationForLog) {
                $this.Filename = $newFilename.Substring( ($newFilename.LastIndexOf($PathSlash) + 1), ($newFilename.Length - $newFilename.LastIndexOf($PathSlash) - 1) )
                $this.Path = $newFilename
            } # end if statement
            else {
                # create directories to match path
                Throw "Error: Directory path does not exist"
            } # end else statement

            if ($this.DebugMode) {
                Write-Host "`"\/`". Location for log -> $($LocationForLog) Filename -> $($this.Filename)" -ForegroundColor Yellow # debugging
            } # end if statement
        } # end if statement

        # Checks if it is file name with extension or not
        elseif ( $newFilename.Contains(".") ) {            
            # full file name received

            $this.Filename = $newFilename
            $this.Path = [String]$PWD + "\" + $this.Filename

            if ($this.DebugMode) {
                Write-Host "`".`" New Path -> $($this.Filename)" -ForegroundColor Yellow # debugging
            } # end if statement
        } # end elseif statement
        
        # Just the name of the file without extension or directory
        else {
            # Just name of file received

            $this.Filename = $newFilename + ".log"
            $this.Path = [String]$PWD + "\" + $this.Filename

            if ($this.DebugMode) {
                Write-Host "Just file name. New Path -> $($this.Filename)" -ForegroundColor Yellow # debugging
            } # end if statement
        } # end else statement
        
        # if file doesn't already exist Create log file
        if ((-Not (Test-Path $this.Path)) -or ($this.FileMode -eq "Write")) {
            if ($this.DebugMode) {
                Write-Host "Creating new log file" -ForegroundColor Magenta
            } # end if statement
            
            $this.CreateLogFile()
        } # end if statement
        else {
            if ($this.DebugMode) {
                Write-Host "Log file $($this.Filename) already exists at $($this.Path)" -ForegroundColor Magenta
            } # end if statement
        } # end else statement

        # BasicConfig Summary
        if ($this.DebugMode) {
            Write-Host "In BasicConfig method. `nLevel -> $($this.strLevel). `nLog file -> $($this.Filename). `nFilemode -> $($this.FileMode)" -ForegroundColor Magenta # debugging
        } # end if statement
    } # end BasicConfig

    <# Overloaded BasicConfig
        User can set level and log file 
        defaults filemode to append
    #>
    [void] BasicConfig([String]$newLevel, [String]$newFilename) {
        $this.BasicConfig($newLevel, $newFilename, "append")
    } # end Overloaded BasicConfig()

    <# Overloaded BasicConfig
        User can set level
        defaults file to "main.log" filemode to append
    #>
    [void] BasicConfig([String]$newLevel) {
        $this.BasicConfig($newLevel, "main.log", "append")
    } # end Overloaded BasicConfig()

    <# CreateLogFile
        Creates the logfile while enforcing the filemode that is set
    #>
    [void] hidden CreateLogFile() {
        if ($this.DebugMode) {
            Write-Host $this.Path -ForegroundColor Yellow
            Write-Host $this.Filename -ForegroundColor Yellow
            Write-Host $this.FileMode -ForegroundColor Yellow
        } # end if statement
        
        try {
            if ($this.DebugMode) {
                Write-Host "Trying to create new log file" -ForegroundColor Magenta
            } # end if statement
            
            if ($this.FileMode -eq "Append") {
                if ($this.DebugMode) {
                    Write-Host "Appending" -ForegroundColor Yellow
                } # end if statement

                New-Item `
                    -Path $this.Path `
                    -ItemType File 
                    # -WhatIf
            } # end if statement
            elseif ($this.FileMode -eq "Write") {
                if ($this.DebugMode) {
                    Write-Host "OverWrite log file" -ForegroundColor Yellow
                } # end if statement
                
                New-Item `
                    -Path $this.Path `
                    -ItemType File `
                    -Force 
                    # -WhatIf
            } # end if statement
            else {
                Write-Host "Error with filemode; `'$($this.FileMode)`' is not recognized defaulting to Append"
                $this.FileMode = "Append"
                $this.CreateLogFile()
            } # end else statement
        } # end try
        catch {
            Write-Host "Error creating log file $($Error[0])" -ForegroundColor Red
            throw
        } # end catch
        
        if ($this.DebugMode) {
            Write-Host "Log file successfully created" -ForegroundColor Yellow
        } # end if statement
    } # end CreateLogFile()

    <# WriteLog
        writes info in set way to the Log file
    #>
    [void] hidden WriteLog([String]$FullMessage, [String]$Level) {
        if ($this.DebugMode) {
            Write-Host "In WriteLog method. Path -> $($this.Path); Filename -> $($this.Filename)" -ForegroundColor Magenta # debugging
        } # end if statement

        if ($this.Path -eq "") {
            $color = ""

            switch ($Level) {
                "NOTSET" { $color = "White" }
                "DEBUG" { $color = "Cyan" }
                "INFO" { $color = "Magenta" }
                "WARNING" { $color = "Yellow" }
                "ERROR" { $color = "Red" }
                "CRITICAL" { $color = "Red" }
                Default { $color = "White" }
            } # end switch

            Write-Host $FullMessage -ForegroundColor $color
        } # end if statement
        else {
            $LogFileExists = Test-Path $this.Path
            if ($LogFileExists) {
                Add-Content `
                    -Path $this.Path `
                    -Value $FullMessage
            } # end if statement
            else {
                Throw "Something went wrong in writing to $($this.Path)"
            } # end else statement
        } # end else statement

    } # end WriteLog()

    <# FormatMessage
        Format the log message based on class variable LogFormat
        | format elements | result                                        |
        | level           | Level of Log write                            | 
        | date            | Run of Get-Date with date format DateFormat   | 
    #>
    [void] hidden FormatMessage([String]$Level, [String]$Message) {
        $LogString = ""
        $FormatArray = $this.LogFormat -split $this.Delimiter
        
        if ($this.DebugMode) {
            Write-Host "In FormatMessage method. Format Array -> $($FormatArray)" -ForegroundColor Magenta # debugging
        } # end if statement

        foreach ($element in $FormatArray) {
            # add log line seperators between information
            if ($LogString -ne "") {
                # Default separator -> ":"
                $LogString += $this.Delimiter
            } # end if statement

            switch ($element) {
                'level' {
                    $LogString += $Level
                } # end 'level'
                'date' { 
                    $LogString += Get-Date -Format $this.DateFormat 
                } # end 'date'
                default { 
                    Write-Host "Error: element $($element) is having an issue when formating message" -ForegroundColor Red # Error
                } # end default
            } # end switch statement
            
        } # end foreach $element

        $this.WriteLog("$($LogString):$($Message)", $Level)
    } # end FormatMessage()

    <# DEBUG 
        Initial function to log a debug message.
        Only continues to write the message if it is set to show DEBUG messages
        Default is WARNING and will not show DEBUG logs. Call BasicConfig to set level
    #>
    [void] debug([String]$Message) {
        if ($this.intLevel -le $this.Level['DEBUG']) {
            if ($this.DebugMode) {
                Write-Host "In debug method. $($this.strLevel) is -LE DEBUG" -ForegroundColor Magenta # debugging
            } # end if statement

            $this.FormatMessage("DEBUG", $Message)
        } # end if statement
        else {
            if ($this.DebugMode) {
                Write-Host "In debug method. $($this.strLevel) is -GT DEBUG" -ForegroundColor Magenta # debugging
            } # end if statement
        } # end else statement
    } # end debug

    <# INFO
        Initial function to log a info message.
        Only continues to write the message if it is set to show INFO messages
        Default is WARNING and will not show INFO logs. Call BasicConfig to set level
    #>
    [void] info([String]$Message) {
        if ($this.intLevel -le $this.Level['INFO']) {
            if ($this.DebugMode) {
                Write-Host "In info method. $($this.strLevel) is -LE INFO" -ForegroundColor Magenta # debugging
            } # end if statement

            $this.FormatMessage("INFO", $Message)
        } # end if statement
        else {
            if ($this.DebugMode) {
                Write-Host "In info method. $($this.strLevel) is -GT INFO" -ForegroundColor Magenta # debugging
            } # end if statement
        } # end else statement
    } # end info

    <# WARNING
        Initial function to log a warning message.
        Only continues to write the message if it is set to show WARNING messages
        Default is WARNING and will show WARNING logs. To change the level Call BasicConfig to set level
    #>
    [void] warning([String]$Message) {
        if ($this.intLevel -le $this.Level['WARNING']) {
            if ($this.DebugMode) {
                Write-Host "In warning method. $($this.strLevel) is -LE WARNING" -ForegroundColor Magenta # debugging
            } # end if statement

            $this.FormatMessage("WARNING", $Message)
        } # end if statement
        else {
            if ($this.DebugMode) {
                Write-Host "In warning method. $($this.strLevel) is -GT WARNING" -ForegroundColor Magenta # debugging
            } # end if statement
        } # end else statement
    } # end warning

    <# ERROR
        Initial function to log a error message.
        Only continues to write the message if it is set to show ERROR messages
        Default is WARNING and will show ERROR logs. To change the level Call BasicConfig to set level
    #>
    [void] error([String]$Message) {
        if ($this.intLevel -le $this.Level['ERROR']) {
            if ($this.DebugMode) {
                Write-Host "In error method. $($this.strLevel) is -LE ERROR" -ForegroundColor Magenta # debugging
            } # end if statement

            $this.FormatMessage("ERROR", $Message)
        } # end if statement
        else {
            if ($this.DebugMode) {
                Write-Host "In error method. $($this.strLevel) is -GT ERROR" -ForegroundColor Magenta # debugging
            } # end if statement
        } # end else statement
    } # end error

    <# CRITICAL
        Initial function to log a critical message.
        Unless a level above critical(50) is added, any of the default levels will show critical errors
        Default is WARNING and will show CRITICAL logs. To change the level Call BasicConfig to set level
    #>
    [void] critical([String]$Message) {
        if ($this.intLevel -le $this.Level['CRITICAL']) {
            if ($this.DebugMode) {
                Write-Host "In critical method. $($this.strLevel) is -LE CRITICAL" -ForegroundColor Magenta # debugging
            } # end if statement

            $this.FormatMessage("CRITICAL", $Message)
        } # end if statement
        else {
            if ($this.DebugMode) {
                Write-Host "In critical method. $($this.strLevel) is -GT CRITICAL" -ForegroundColor Magenta # debugging
            } # end if statement
        } # end else statement
    } # end critical

    <# GetLogLevel
        Returns a hashtable with 2 elements
        strLevel -> Level as a string
        value -> Level as an integer    
    #>
    [hashtable] GetLogLevel() {
        $CurrentLevel = @{
            Value = $this.intLevel
            Level = $this.strLevel
        } # end $CurrentLevel
        return $CurrentLevel
    } # end GetLogLevel

    <# SetLevel
        - Takes in the string value of the level
        - checks if string value is a valid level
        - Sets the level to the specified level
        Level Values
            Set the level to its numeric value
            Level String,   Numeric value
            CRITICAL,       50
            ERROR,          40
            WARNING,        30
            INFO,           20
            DEBUG,          10
            NOTSET,         0
    #>
    [void] SetLevel([String]$strLevel) {
        if ($this.Level.ContainsKey($strLevel)) {
            $this.intLevel = $this.Level[$strLevel]
            $this.strLevel = $strLevel
        } # end if statement
        else {
            Write-Host "Error: Level $($strLevel) is not recognized as a level" -ForegroundColor Red
            throw
        } # end catch
        

        # if in debug mode
        if ($this.DebugMode) {
            Write-Host "In SetLevel method; Level set to $($strLevel) with a value of $($this.intLevel)" -ForegroundColor Magenta # debugging
        } # end if statement
    } # end SetLevel

    [String] GetLogHeader() {
        return $this.LogHeader
    } # end GetLogHeader

    [void] SetLogHeader([String]$Header) {
        $HeaderTest = $Header -split $this.Delimiter
        $FormatTest = $this.LogFormat -split $this.Delimiter
        
        if ($HeaderTest.Count -ne $FormatTest.Count) {
            Write-Warning "Header might not be properly set. Either missing a header element or header does not contain same delimiter as log($($this.Delimiter))"
        } # end if statement

        $this.LogHeader = $Header
    } # end SetLogHeader
} # end Logging class