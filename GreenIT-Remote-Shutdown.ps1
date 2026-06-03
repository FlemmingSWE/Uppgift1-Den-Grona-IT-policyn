# GreenIT-Remote-Shutdown.ps1
# Scans the subnet and triggers GreenIT-Shutdown.ps1 on all live hosts.

# --- CONFIGURATION ---
$subnet        = "10.0.66"
$scriptPath    = "\\ad01\ITSEC2026\scripts\GreenIT-Shutdown.ps1"  # UNC path all clients can reach
$credential    = Get-Credential  # Remove if using a service account via scheduled task

# --- STEP 1: Scan for live hosts ---
Write-Host "Scanning $subnet.0/24 for live hosts..." -ForegroundColor Cyan

$liveHosts = 1..254 | ForEach-Object -Parallel {
    $ip = "$using:subnet.$_"
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue) {
        $ip
    }
} -ThrottleLimit 50

$sorted = $liveHosts | Sort-Object { [int]($_ -split '\.')[-1] }
Write-Host "$($sorted.Count) host(s) found.`n" -ForegroundColor Green

# --- STEP 2: Run shutdown script on each live host ---
foreach ($ip in $sorted) {
    Write-Host "Sending shutdown to $ip..." -ForegroundColor Yellow
    try {
        Invoke-Command -ComputerName $ip -Credential $credential -FilePath $scriptPath -AsJob
    }
    catch {
        Write-Warning "Failed to reach $ip: $_"
    }
}

Write-Host "`nDone. Shutdown jobs dispatched." -ForegroundColor Cyan