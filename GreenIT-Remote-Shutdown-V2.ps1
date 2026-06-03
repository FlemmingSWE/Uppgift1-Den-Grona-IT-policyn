# GreenIT-Remote-Shutdown-IP.ps1
# Skannar 192.168.1.1 till 192.168.1.20.
# Exkluderar servern 192.168.1.2.
# Kör shutdown via PowerShell Remoting.
# Loggar centralt från servern.

# =========================
# KONFIGURATION
# =========================

$subnetPrefix = "192.168.1"
$startIP = 1
$endIP = 20

# Servern ska inte stängas av
$excludedIPs = @(
    "192.168.1.2"
)

# Central loggfil på servern
$logPath = "\\ad01\ITSEC2026\log\Shutdown_log.txt"

# 900 sekunder = 15 minuter
$shutdownTimerSeconds = 900

$shutdownMessage = "Green IT: Datorn stängs av om 15 minuter. Spara ditt arbete nu."

# =========================
# LOGGFUNKTION
# =========================

function Write-GreenITLog {
    param (
        [string]$Status,
        [string]$Target,
        [string]$Message
    )

    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $serverName = $env:COMPUTERNAME

    $post = "$time | SERVER: $serverName | TARGET: $Target | STATUS: $Status | MEDDELANDE: $Message"

    Add-Content -Path $logPath -Value $post -Encoding UTF8
}

# =========================
# KONTROLLERA LOGGMAPP
# =========================

$logFolder = Split-Path $logPath

if (-not (Test-Path -Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder -Force | Out-Null
}

Write-GreenITLog -Status "START" -Target "SERVER" -Message "Green IT-script startades."

# =========================
# TRUSTEDHOSTS FÖR IP-ADRESSER
# =========================

Write-Host "Konfigurerar TrustedHosts för 192.168.1.* ..." -ForegroundColor Cyan

try {
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value "192.168.1.*" -Force
    Restart-Service WinRM
    Write-Host "TrustedHosts konfigurerat." -ForegroundColor Green
}
catch {
    Write-Warning "Kunde inte konfigurera TrustedHosts. Kör PowerShell som administratör. Fel: $_"
    Write-GreenITLog -Status "TRUSTEDHOSTS_FEL" -Target "SERVER" -Message "$_"
    exit
}

# Konto med administratörsrättigheter på klienterna
$credential = Get-Credential

# =========================
# REMOTE SCRIPTBLOCK
# Detta körs på klienten
# =========================

$remoteShutdownScript = {
    param (
        [int]$RemoteShutdownTimerSeconds,
        [string]$RemoteShutdownMessage
    )

    # Kör shutdown lokalt på klienten
    shutdown.exe /s /t $RemoteShutdownTimerSeconds /c "$RemoteShutdownMessage"

    # Returnerar status till servern
    return "Shutdown schemalagd på $env:COMPUTERNAME om $RemoteShutdownTimerSeconds sekunder."
}

# =========================
# STEG 1: SKANNA 192.168.1.1 - 192.168.1.20
# =========================

Write-Host "Skannar $subnetPrefix.$startIP till $subnetPrefix.$endIP efter aktiva klienter..." -ForegroundColor Cyan

Get-Job | Where-Object { $_.Name -like "PingJob_*" } | Remove-Job -Force -ErrorAction SilentlyContinue

foreach ($i in $startIP..$endIP) {
    $ip = "$subnetPrefix.$i"

    if ($excludedIPs -contains $ip) {
        Write-Host "Hoppar över exkluderad IP: $ip" -ForegroundColor DarkYellow
        Write-GreenITLog -Status "EXKLUDERAD" -Target $ip -Message "IP-adressen är exkluderad."
        continue
    }

    Start-Job -Name "PingJob_$i" -ScriptBlock {
        param (
            [string]$TargetIP
        )

        if (Test-Connection -ComputerName $TargetIP -Count 1 -Quiet -ErrorAction SilentlyContinue) {
            return $TargetIP
        }
    } -ArgumentList $ip | Out-Null
}

Wait-Job -Name "PingJob_*" | Out-Null

$liveHosts = Get-Job -Name "PingJob_*" | Receive-Job | Where-Object { $_ }

Get-Job -Name "PingJob_*" | Remove-Job -Force

if (-not $liveHosts -or $liveHosts.Count -eq 0) {
    Write-Warning "Inga aktiva klienter hittades."
    Write-GreenITLog -Status "INGA_KLIENTER" -Target "N/A" -Message "Inga aktiva klienter hittades."
    exit
}

$liveHosts = $liveHosts | Where-Object { $excludedIPs -notcontains $_ }
$sortedHosts = $liveHosts | Sort-Object { [int]($_ -split '\.')[-1] }

Write-Host "`n$($sortedHosts.Count) aktiv(a) klient(er) hittades:`n" -ForegroundColor Green

foreach ($hostIp in $sortedHosts) {
    Write-Host "Aktiv klient hittad: $hostIp" -ForegroundColor Green
    Write-GreenITLog -Status "AKTIV_KLIENT" -Target $hostIp -Message "Klienten svarade på ping."
}

# =========================
# STEG 2: TESTA REMOTING OCH SKICKA SHUTDOWN
# =========================

Write-Host "`nSkickar Green IT shutdown via PowerShell Remoting..." -ForegroundColor Cyan

$shutdownJobs = @()

foreach ($ip in $sortedHosts) {
    Write-Host "Testar PowerShell Remoting mot $ip..." -ForegroundColor Yellow

    try {
        $testResult = Invoke-Command `
            -ComputerName $ip `
            -Credential $credential `
            -ScriptBlock { hostname } `
            -ErrorAction Stop

        Write-Host "Remoting fungerar mot $ip. Datornamn: $testResult" -ForegroundColor Green
        Write-GreenITLog -Status "REMOTING_OK" -Target $ip -Message "Remoting fungerar. Datornamn: $testResult"
    }
    catch {
        Write-Warning "Remoting fungerar inte mot $ip. Hoppar över. Fel: $_"
        Write-GreenITLog -Status "REMOTING_FEL" -Target $ip -Message "$_"
        continue
    }

    Write-Host "Skickar shutdown till $ip..." -ForegroundColor Yellow

    try {
        $job = Invoke-Command `
            -ComputerName $ip `
            -Credential $credential `
            -ScriptBlock $remoteShutdownScript `
            -ArgumentList $shutdownTimerSeconds, $shutdownMessage `
            -AsJob `
            -ErrorAction Stop

        $shutdownJobs += $job

        Write-Host "Shutdown-jobb startat för $ip" -ForegroundColor Green
        Write-GreenITLog -Status "SHUTDOWN_JOBB_STARTAT" -Target $ip -Message "Shutdown-jobb startat."
    }
    catch {
        Write-Warning "Kunde inte starta shutdown på $ip. Fel: $_"
        Write-GreenITLog -Status "SHUTDOWN_START_FEL" -Target $ip -Message "$_"
    }
}

# =========================
# STEG 3: KONTROLLERA JOBBRESULTAT
# =========================

Write-Host "`nKontrollerar status på shutdown-jobben..." -ForegroundColor Cyan

Start-Sleep -Seconds 3

foreach ($job in $shutdownJobs) {
    $jobStatus = Get-Job -Id $job.Id

    if ($jobStatus.State -eq "Failed") {
        Write-Host "FAILED: $($job.Location)" -ForegroundColor Red
        $errorText = Receive-Job -Id $job.Id -Keep 2>&1
        Write-Host $errorText
        Write-GreenITLog -Status "SHUTDOWN_FAILED" -Target $job.Location -Message "$errorText"
    }
    elseif ($jobStatus.State -eq "Completed") {
        Write-Host "COMPLETED: $($job.Location)" -ForegroundColor Green
        $result = Receive-Job -Id $job.Id -Keep
        Write-Host $result
        Write-GreenITLog -Status "SHUTDOWN_SCHEMALAGD" -Target $job.Location -Message "$result"
    }
    elseif ($jobStatus.State -eq "Running") {
        Write-Host "RUNNING: $($job.Location)" -ForegroundColor Yellow
        Write-GreenITLog -Status "SHUTDOWN_RUNNING" -Target $job.Location -Message "Jobbet körs fortfarande."
    }
    else {
        Write-Host "$($jobStatus.State): $($job.Location)" -ForegroundColor Gray
        Write-GreenITLog -Status $jobStatus.State -Target $job.Location -Message "Jobbstatus: $($jobStatus.State)"
    }
}

Write-GreenITLog -Status "KLAR" -Target "SERVER" -Message "Scriptet är klart."
Write-Host "`nKlart." -ForegroundColor Cyan
