# GreenIT-Shutdown.ps1
# Varnar anvandaren innan shutdown och loggar handelsen

$logPath = "C:\Logs\shutdown_log.txt"
$logFolder = Split-Path $logPath

if (-not (Test-Path -Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder -Force | Out-Null
}

function Write-GreenITLog {
    param (
        [string]$Status,
        [string]$Message
    )

    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $computerName = $env:COMPUTERNAME
    $post = "$time | DATORNAMN: $computerName | STATUS: $Status | MEDDELANDE: $Message"

    Add-Content -Path $logPath -Value $post -Encoding UTF8
}

try {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    Write-GreenITLog -Status "CIM_OK" -Message "OS: $($os.Caption), Senaste start: $($os.LastBootUpTime)"
}
catch {
    Write-GreenITLog -Status "CIM_FEL" -Message "$_"
}

$msg15 = "Green IT: Datorn stangs av om 15 minuter. Spara ditt arbete nu."
msg * /time:60 $msg15
Write-GreenITLog -Status "VARNING_15_MIN" -Message $msg15

Start-Sleep -Seconds 840

$msg1 = "Green IT: Datorn stangs av om 1 minut. Spara och stang dina program."
msg * /time:60 $msg1
Write-GreenITLog -Status "VARNING_1_MIN" -Message $msg1

Start-Sleep -Seconds 60

Write-GreenITLog -Status "SHUTDOWN_BEGARD" -Message "Datorn stangs av efter varningar."

shutdown /s /t 0 /c "Green IT: Datorn stangs av for att spara energi."


