$hostname = Read-Host "📞 Enter host"
$port = Read-Host "🔌 Enter port"
Test-NetConnection -ComputerName $hostname -Port $port
