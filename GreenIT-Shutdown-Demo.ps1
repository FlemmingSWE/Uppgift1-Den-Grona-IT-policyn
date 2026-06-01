# GreenIT-Shutdown-DEMO.ps1
# Testar loggning utan att stanga av datorn

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

    $post = "$time | DATORNAMN: $computerName | STATUS: DEMO - Shutdown skulle ha skickats | OS: $osName | SENASTE START: $lastBoot"

    Add-Content -Path $logPath -Value $post -Encoding UTF8
}
catch {
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $post = "$time | DATORNAMN: $env:COMPUTERNAME | STATUS: FEL VID CIM/WMI | FEL: $_"

    Add-Content -Path $logPath -Value $post -Encoding UTF8
}

Write-Host "Demo klar. Kontrollera C:\Logs\shutdown_log.txt"

