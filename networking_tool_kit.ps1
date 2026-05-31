# ============================================
# Networking Tool Kit - Red Mx (Windows Version)
# ============================================

# Requirements: PowerShell 5.1 or higher

# Global variables
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ToolsDir = Join-Path $ScriptDir "tools"

# Function to show banner
function Show-Banner {
    Clear-Host
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Red
    Write-Host "║      🔥 RED MX NETWORK TOOL KIT 🔥      ║" -ForegroundColor Cyan
    Write-Host "║    Herramientas de red profesional     ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Red
    Write-Host "          Versión 2.0 - Windows`n" -ForegroundColor Yellow
}

# Function to show main menu
function Show-Menu {
    Write-Host "┌─────────────────────────────────────┐" -ForegroundColor Cyan
    Write-Host "│  CATEGORÍA                         │" -ForegroundColor Cyan
    Write-Host "├─────────────────────────────────────┤" -ForegroundColor Cyan
    Write-Host "│  1. Diagnóstico de red              │" -ForegroundColor Green
    Write-Host "│     1.1 Ping                        │" -ForegroundColor Blue
    Write-Host "│     1.2 Traceroute                  │" -ForegroundColor Blue
    Write-Host "├─────────────────────────────────────┤" -ForegroundColor Cyan
    Write-Host "│  2. Información de red              │" -ForegroundColor Green
    Write-Host "│     2.1 Netstat                     │" -ForegroundColor Blue
    Write-Host "│     2.2 Nslookup                    │" -ForegroundColor Blue
    Write-Host "├─────────────────────────────────────┤" -ForegroundColor Cyan
    Write-Host "│  3. Resolución de nombres           │" -ForegroundColor Green
    Write-Host "│     3.1 Whois                       │" -ForegroundColor Blue
    Write-Host "│     3.2 Telnet                      │" -ForegroundColor Blue
    Write-Host "├─────────────────────────────────────┤" -ForegroundColor Cyan
    Write-Host "│  4. Conexión remota                 │" -ForegroundColor Green
    Write-Host "│     4.1 Cliente SSH                 │" -ForegroundColor Blue
    Write-Host "│     4.2 Escaneo de puertos          │" -ForegroundColor Blue
    Write-Host "├─────────────────────────────────────┤" -ForegroundColor Cyan
    Write-Host "│  5. Transferencia de archivos       │" -ForegroundColor Green
    Write-Host "│     5.1 Descarga (Invoke-WebRequest)│" -ForegroundColor Blue
    Write-Host "│     5.2 Monitoreo de red            │" -ForegroundColor Blue
    Write-Host "├─────────────────────────────────────┤" -ForegroundColor Cyan
    Write-Host "│  0. Salir                           │" -ForegroundColor Red
    Write-Host "└─────────────────────────────────────┘" -ForegroundColor Cyan
    Write-Host "➤ Selecciona una opción (ej: 1.1 o 0): " -ForegroundColor Yellow -NoNewline
}

# Function to run a specific tool
function Run-Tool {
    param(
        [int]$Category,
        [int]$Tool
    )
    
    $toolFile = ""
    
    switch ("$Category-$Tool") {
        "1-1" { $toolFile = "01_ping.ps1" }
        "1-2" { $toolFile = "02_traceroute.ps1" }
        "2-1" { $toolFile = "03_netstat.ps1" }
        "2-2" { $toolFile = "04_nslookup.ps1" }
        "3-1" { $toolFile = "05_whois.ps1" }
        "3-2" { $toolFile = "06_telnet.ps1" }
        "4-1" { $toolFile = "07_ssh.ps1" }
        "4-2" { $toolFile = "08_port_scanner.ps1" }
        "5-1" { $toolFile = "09_download.ps1" }
        "5-2" { $toolFile = "10_monitor.ps1" }
        default { return $false }
    }
    
    $toolPath = Join-Path $ToolsDir $toolFile
    
    if (Test-Path $toolPath) {
        Write-Host "`n▶ Ejecutando herramienta..." -ForegroundColor Green
        Start-Sleep -Seconds 1
        & $toolPath
    } else {
        Write-Host "`n❌ Error: Herramienta no encontrada en $toolPath" -ForegroundColor Red
        Write-Host "💡 Asegúrate de que los archivos estén en la carpeta 'tools\'" -ForegroundColor Yellow
    }
    
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Read-Host "Presiona [Enter] para continuar"
    return $true
}

# Function to check if tools directory exists
function Validate-Tools {
    if (-not (Test-Path $ToolsDir)) {
        Write-Host "❌ Error: No se encuentra la carpeta 'tools\'" -ForegroundColor Red
        Write-Host "💡 Crea la carpeta y coloca los scripts de herramientas allí." -ForegroundColor Yellow
        exit 1
    }
}

# Function to check PowerShell version
function Check-PowerShellVersion {
    $psVersion = $PSVersionTable.PSVersion.Major
    if ($psVersion -lt 5) {
        Write-Host "⚠ Advertencia: Se recomienda PowerShell 5.1 o superior (versión actual: $psVersion)" -ForegroundColor Yellow
        Write-Host "Algunas herramientas pueden no funcionar correctamente." -ForegroundColor Yellow
        Read-Host "Presiona [Enter] para continuar"
    }
}

# Main execution
function Main {
    Validate-Tools
    Check-PowerShellVersion
    
    while ($true) {
        Show-Banner
        Show-Menu
        $choice = Read-Host
        
        switch ($choice) {
            "1.1" { Run-Tool -Category 1 -Tool 1 }
            "1.2" { Run-Tool -Category 1 -Tool 2 }
            "2.1" { Run-Tool -Category 2 -Tool 1 }
            "2.2" { Run-Tool -Category 2 -Tool 2 }
            "3.1" { Run-Tool -Category 3 -Tool 1 }
            "3.2" { Run-Tool -Category 3 -Tool 2 }
            "4.1" { Run-Tool -Category 4 -Tool 1 }
            "4.2" { Run-Tool -Category 4 -Tool 2 }
            "5.1" { Run-Tool -Category 5 -Tool 1 }
            "5.2" { Run-Tool -Category 5 -Tool 2 }
            "0" { 
                Write-Host "`n👋 ¡Gracias por usar Networking Tool Kit - Red Mx!" -ForegroundColor Green
                exit 0
            }
            default {
                Write-Host "`n❌ Opción inválida. Usa el formato 'número.número' (ej: 1.1)" -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    }
}

# Run the program
Main
