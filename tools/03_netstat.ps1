Write-Host "📊 Active connections:" -ForegroundColor Cyan
netstat -an | Select-String "LISTENING|ESTABLISHED"
