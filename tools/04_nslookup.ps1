$domain = Read-Host "🔍 Enter domain"
Resolve-DnsName -Name $domain
