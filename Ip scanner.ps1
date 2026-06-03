$subnet = "10.0.66"
$liveHosts = 1..254 | ForEach-Object -Parallel {
    $ip = "$using:subnet.$_"
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue) {
        $ip
    }
} -ThrottleLimit 50

$sorted = $liveHosts | Sort-Object { [int]($_ -split '\.')[-1] }
$sorted | ForEach-Object { Write-Host "$_ is UP" -ForegroundColor Green }

Write-Host "`n$($sorted.Count) host(s) active on $subnet.0/24" -ForegroundColor Cyan