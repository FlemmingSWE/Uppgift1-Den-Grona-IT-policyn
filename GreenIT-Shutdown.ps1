# GreenIT-Shutdown.ps1
# Loggar information och stanger sedan av klienten

$logPath = "C:\Logs\shutdown_log.txt"
$logFolder = Split-Path $logPath

if (-not (Test-Path -Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder -Force | Out-Null
}

try {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem

    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $computerName = $env:COMPUTERNAME
    $lastBoot = $os.LastBootUpTime
    $osName = $os.Caption

    $post = "$time | DATORNAMN: $computerName | STATUS: Shutdown begard | OS: $osName | SENASTE START: $lastBoot"

    Add-Content -Path $logPath -Value $post -Encoding UTF8
}
catch {
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $post = "$time | DATORNAMN: $env:COMPUTERNAME | STATUS: FEL VID CIM/WMI | FEL: $_"

    Add-Content -Path $logPath -Value $post -Encoding UTF8
}

shutdown /s /f /t 60 /c "Green IT: Datorn stangs av for att spara energi."

