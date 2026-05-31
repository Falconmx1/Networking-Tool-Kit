$target = Read-Host "🌐 Enter IP or domain"
Test-Connection -ComputerName $target -Count 4
