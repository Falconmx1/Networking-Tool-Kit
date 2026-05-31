$target = Read-Host "🎯 Enter target IP"
$startPort = Read-Host "🔢 Start port"
$endPort = Read-Host "🔢 End port"
for ($port = $startPort; $port -le $endPort; $port++) {
    $connection = Test-NetConnection -ComputerName $target -Port $port -WarningAction SilentlyContinue
    if ($connection.TcpTestSucceeded) {
        Write-Host "Port $port is OPEN" -ForegroundColor Green
    }
}
