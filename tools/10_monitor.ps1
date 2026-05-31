Write-Host "📈 Monitoring network traffic (Ctrl+C to stop)" -ForegroundColor Cyan
Get-Counter -Counter "\Network Interface(*)\Bytes Total/sec" -SampleInterval 2 -MaxSamples 10
