# GreenIT-Shutdown.ps1
# Detta är riktiga scriptet.
# Det varnar användaren, skriver logg och stänger sedan av datorn.

# Här sparas loggfilen på klienten
$logPath = "C:\Logs\shutdown_log.txt"

# Hämtar mappen från loggsökvägen
$logFolder = Split-Path $logPath

# Skapar loggmappen om den saknas
if (-not (Test-Path -Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder -Force | Out-Null
}

# Funktion för att skriva till loggen
function Write-GreenITLog {
    param (
        [string]$Status,
        [string]$Message
    )

    # Hämtar aktuell tid och datornamn
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $computerName = $env:COMPUTERNAME

    # Skapar loggraden
    $post = "$time | DATORNAMN: $computerName | STATUS: $Status | MEDDELANDE: $Message"

    # Skriver loggraden till filen
    Add-Content -Path $logPath -Value $post -Encoding UTF8
}

# Hämtar systeminformation med CIM/WMI
try {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    Write-GreenITLog -Status "CIM_OK" -Message "OS: $($os.Caption), Senaste start: $($os.LastBootUpTime)"
}
catch {
    Write-GreenITLog -Status "CIM_FEL" -Message "$_"
}

# Första varningen, 15 minuter innan shutdown
$msg15 = "Green IT: Datorn stängs av om 15 minuter. Spara ditt arbete nu."
msg * /time:60 $msg15
Write-GreenITLog -Status "VARNING_15_MIN" -Message $msg15

# Väntar 14 minuter
Start-Sleep -Seconds 840

# Sista varningen, 1 minut innan shutdown
$msg1 = "Green IT: Datorn stängs av om 1 minut. Spara och stäng dina program."
msg * /time:60 $msg1
Write-GreenITLog -Status "VARNING_1_MIN" -Message $msg1

# Väntar sista minuten
Start-Sleep -Seconds 60

# Loggar att shutdown ska köras
Write-GreenITLog -Status "SHUTDOWN_BEGÄRD" -Message "Datorn stängs av efter varningar."

# Här stängs datorn av
shutdown /s /t 0 /c "Green IT: Datorn stängs av för att spara energi."
