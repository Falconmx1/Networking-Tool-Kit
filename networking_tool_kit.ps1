function Show-Banner {
    Clear-Host
    Write-Host "==================================" -ForegroundColor Red
    Write-Host "        🔧 RED MX TOOL KIT 🔧        " -ForegroundColor Cyan
    Write-Host "==================================" -ForegroundColor Red
}

function Run-Tool {
    param([string]$ToolName)
    $toolPath = Join-Path $PSScriptRoot "tools\$ToolName.ps1"
    if (Test-Path $toolPath) {
        & $toolPath
    } else {
        Write-Host "Herramienta no encontrada: $toolPath" -ForegroundColor Red
    }
    Read-Host "Presiona Enter para continuar"
}

while ($true) {
    Show-Banner
    Write-Host "1. Herramientas de diagnóstico"
    Write-Host "2. Herramientas de información de red"
    Write-Host "3. Herramientas de resolución de nombres"
    Write-Host "4. Herramientas de conexión remota"
    Write-Host "5. Herramientas de escaneo"
    Write-Host "6. Herramientas de transferencia"
    Write-Host "7. Herramientas de monitoreo"
    Write-Host "8. Herramientas de configuración"
    Write-Host "9. Utilidades generales"
    Write-Host "10. Salir"
    $opcion = Read-Host "Selecciona una opción (1-10)"
    
    switch ($opcion) {
        "1" { Run-Tool "01_ping" }
        "2" { Run-Tool "02_traceroute" }
        "3" { Run-Tool "03_netstat" }
        "4" { Run-Tool "04_nslookup" }
        "5" { Run-Tool "05_whois" }
        "6" { Run-Tool "06_telnet" }
        "7" { Run-Tool "07_ssh" }
        "8" { Run-Tool "08_port_scanner" }
        "9" { Run-Tool "09_download" }
        "10" { Write-Host "Saliendo..."; exit 0 }
        default { Write-Host "Opción inválida"; Start-Sleep -Seconds 1 }
    }
}
