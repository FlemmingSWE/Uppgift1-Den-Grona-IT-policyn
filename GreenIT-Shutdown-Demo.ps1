# GreenIT-Shutdown-DEMO.ps1
# Detta är demo-versionen.
# Den testar logg och varningar men stänger inte av datorn.

# Här bestämmer vi var loggfilen ska sparas
$logPath = "C:\Logs\shutdown_log.txt"

# Här hämtar vi bara mappen C:\Logs från sökvägen
$logFolder = Split-Path $logPath

# Om mappen inte finns så skapas den
if (-not (Test-Path -Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder -Force | Out-Null
}

# Denna funktion skriver en rad till loggfilen
function Write-GreenITLog {
    param (
        [string]$Status,
        [string]$Message
    )

    # Hämtar aktuell tid och datornamn
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $computerName = $env:COMPUTERNAME

    # Här bygger vi ihop raden som ska sparas i loggen
    $post = "$time | DATORNAMN: $computerName | STATUS: $Status | MEDDELANDE: $Message"

    # Här sparas raden i loggfilen
    Add-Content -Path $logPath -Value $post -Encoding UTF8
}

# Här testar vi att hämta information från datorn med CIM/WMI
try {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    Write-GreenITLog -Status "CIM_OK" -Message "OS: $($os.Caption), Senaste start: $($os.LastBootUpTime)"
}
catch {
    Write-GreenITLog -Status "CIM_FEL" -Message "$_"
}

# Första varningen till användaren
$msg15 = "Green IT: Datorn stängs av om 15 minuter. Spara ditt arbete nu."
msg * /time:60 $msg15
Write-GreenITLog -Status "VARNING_15_MIN" -Message $msg15

# Kort väntetid i demo så man slipper vänta 15 minuter
Start-Sleep -Seconds 30

# Sista varningen till användaren
$msg1 = "Green IT: Datorn stängs av om 1 minut. Spara och stäng dina program."
msg * /time:60 $msg1
Write-GreenITLog -Status "VARNING_1_MIN" -Message $msg1

# Kort väntetid i demo
Start-Sleep -Seconds 10

# Här loggar vi bara att shutdown skulle ha hänt
Write-GreenITLog -Status "DEMO" -Message "Här skulle datorn ha stängts av."

Write-Host "Demo klar. Kontrollera loggen i C:\Logs\shutdown_log.txt"
