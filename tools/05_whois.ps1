# Requiere el módulo Whois (instalar con: Install-Module -Name Whois)
$target = Read-Host "📋 Enter domain or IP"
whois $target
