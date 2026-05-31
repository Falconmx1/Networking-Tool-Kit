$url = Read-Host "⬇️ Enter URL to download"
$filename = Read-Host "📁 Save as"
Invoke-WebRequest -Uri $url -OutFile $filename
