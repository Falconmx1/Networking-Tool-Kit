$target = Read-Host "Ingresa la dirección IP o dominio a hacer ping"
Test-Connection -ComputerName $target -Count 4
