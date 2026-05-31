# ============================================
# Networking Tool Kit - Red Mx (Windows v2.1)
# ============================================

# Requirements: PowerShell 5.1 or higher

# Global variables
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ToolsDir = Join-Path $ScriptDir "tools"
$ConfigFile = Join-Path $ScriptDir ".config"
$LogDir = Join-Path $ScriptDir "logs"
$LogFile = Join-Path $LogDir "activity.log"
$VersionFile = Join-Path $ScriptDir ".version"
$CurrentVersion = "2.1.0"

# ============================================
# LOGGING FUNCTIONS
# ============================================

function Initialize-Logging {
    if (-not (Test-Path $LogDir)) {
        New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
    }
    
    if (-not (Test-Path $LogFile)) {
        New-Item -ItemType File -Path $LogFile -Force | Out-Null
    }
    
    # Rotate log if >10MB
    if ((Get-Item $LogFile).Length -gt 10MB) {
        Move-Item $LogFile "$LogFile.old" -Force
        New-Item -ItemType File -Path $LogFile -Force | Out-Null
        Write-Log "INFO" "Log rotated (was >10MB)"
    }
}

function Write-Log {
    param(
        [string]$Level,
        [string]$Message
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $user = $env:USERNAME
    $logEntry = "[$timestamp] [$Level] [$user] $Message"
    
    Add-Content -Path $LogFile -Value $logEntry
    
    if ($Level -eq "DEBUG" -and $env:ENABLE_DEBUG -eq "true") {
        Write-Host "[DEBUG] $Message" -ForegroundColor Yellow
    }
}

# ============================================
# AUTO-UPDATE FUNCTIONS
# ============================================

function Check-ForUpdates {
    Write-Log "INFO" "Checking for updates..."
    
    # Check if git is available
    $gitPath = Get-Command git -ErrorAction SilentlyContinue
    if (-not $gitPath) {
        Write-Log "WARNING" "Git not installed, cannot auto-update"
        return $false
    }
    
    # Check if we're in a git repo
    if (-not (Test-Path (Join-Path $ScriptDir ".git"))) {
        Write-Log "WARNING" "Not a git repository, skipping auto-update"
        return $false
    }
    
    Push-Location $ScriptDir
    
    # Fetch latest changes
    git fetch origin 2>&1 | Out-Null
    
    # Get local and remote hashes
    $localHash = git rev-parse HEAD
    $remoteHash = git rev-parse origin/main
    
    Pop-Location
    
    if ($localHash -ne $remoteHash) {
        Write-Log "INFO" "Updates available! Local: $localHash, Remote: $remoteHash"
        return $true
    } else {
        Write-Log "DEBUG" "Already up to date"
        return $false
    }
}

function Perform-Update {
    Write-Host "`n🔄 Actualizaciones disponibles para Networking Tool Kit" -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "Versión actual: $CurrentVersion" -ForegroundColor Green
    
    Push-Location $ScriptDir
    git fetch origin 2>&1 | Out-Null
    
    Write-Host "`n📝 Cambios encontrados:" -ForegroundColor Yellow
    git log --oneline HEAD..origin/main --max-count=5 2>$null | ForEach-Object {
        Write-Host "  • $_" -ForegroundColor Cyan
    }
    
    Write-Host "`n¿Deseas actualizar ahora? [s/N]: " -ForegroundColor Yellow -NoNewline
    $answer = Read-Host
    
    if ($answer -match "^[Ss]$") {
        Write-Host "▶ Actualizando..." -ForegroundColor Green
        Write-Log "INFO" "Starting update process"
        
        # Stash local changes
        git stash push -m "auto-stash-before-update" 2>&1 | Out-Null
        
        # Pull changes
        $pullResult = git pull origin main 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Actualización completada con éxito!" -ForegroundColor Green
            Write-Log "INFO" "Update completed successfully"
            
            $CurrentVersion | Out-File -FilePath $VersionFile -Force
            
            Write-Host "`n⚠️ Se recomienda reiniciar la herramienta para aplicar los cambios" -ForegroundColor Yellow
            Read-Host "Presiona Enter para continuar"
            
            # Restart script
            & $MyInvocation.MyCommand.Path
            exit
        } else {
            Write-Host "❌ Error durante la actualización" -ForegroundColor Red
            Write-Log "ERROR" "Update failed: $pullResult"
            git stash pop 2>&1 | Out-Null
            Read-Host "Presiona Enter para continuar"
        }
    } else {
        Write-Host "Actualización cancelada" -ForegroundColor Yellow
        Write-Log "INFO" "Update cancelled by user"
        Start-Sleep -Seconds 1
    }
    
    Pop-Location
}

# ============================================
# UI FUNCTIONS
# ============================================

function Show-Banner {
    Clear-Host
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Red
    Write-Host "║      🔥 RED MX NETWORK TOOL KIT 🔥      ║" -ForegroundColor Cyan
    Write-Host "║    Herramientas de red profesional     ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Red
    Write-Host "          Versión $CurrentVersion - Windows`n" -ForegroundColor Yellow
    
    if (Test-Path $VersionFile) {
        $lastVersion = Get-Content $VersionFile
        if ($lastVersion -ne $CurrentVersion) {
            Write-Host "✨ Actualizado recientemente a v$CurrentVersion" -ForegroundColor Green
        }
    }
    Write-Host ""
}

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
    Write-Host "│  U. Buscar actualizaciones          │" -ForegroundColor Magenta
    Write-Host "│  L. Ver logs de actividad           │" -ForegroundColor Magenta
    Write-Host "│  C. Limpiar logs                    │" -ForegroundColor Magenta
    Write-Host "├─────────────────────────────────────┤" -ForegroundColor Cyan
    Write-Host "│  0. Salir                           │" -ForegroundColor Red
    Write-Host "└─────────────────────────────────────┘" -ForegroundColor Cyan
    Write-Host "➤ Selecciona una opción (ej: 1.1, U, L, C, 0): " -ForegroundColor Yellow -NoNewline
}

# ============================================
# UTILITY FUNCTIONS
# ============================================

function View-Logs {
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "📋 Últimas 50 líneas del log de actividad:" -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan
    
    if (Test-Path $LogFile) {
        Get-Content $LogFile -Tail 50 | ForEach-Object {
            if ($_ -match "ERROR") {
                Write-Host $_ -ForegroundColor Red
            } elseif ($_ -match "WARNING") {
                Write-Host $_ -ForegroundColor Yellow
            } elseif ($_ -match "INFO") {
                Write-Host $_ -ForegroundColor Green
            } else {
                Write-Host $_
            }
        }
    } else {
        Write-Host "No hay logs aún." -ForegroundColor Yellow
    }
    
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Read-Host "Presiona [Enter] para continuar"
}

function Clear-Logs {
    Write-Host "`n⚠️ ¿Estás seguro de que quieres limpiar todos los logs? [s/N]: " -ForegroundColor Yellow -NoNewline
    $answer = Read-Host
    
    if ($answer -match "^[Ss]$") {
        Clear-Content $LogFile -Force
        Write-Log "INFO" "Logs cleared by user"
        Write-Host "✅ Logs limpiados correctamente" -ForegroundColor Green
    } else {
        Write-Host "Operación cancelada" -ForegroundColor Yellow
    }
    Start-Sleep -Seconds 1
}

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
    
    Write-Log "INFO" "Executing tool: $toolFile"
    
    $toolPath = Join-Path $ToolsDir $toolFile
    
    if (Test-Path $toolPath) {
        Write-Host "`n▶ Ejecutando herramienta..." -ForegroundColor Green
        Start-Sleep -Seconds 1
        & $toolPath
        Write-Log "INFO" "Tool execution completed: $toolFile"
    } else {
        Write-Host "`n❌ Error: Herramienta no encontrada en $toolPath" -ForegroundColor Red
        Write-Log "ERROR" "Tool not found: $toolFile"
    }
    
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Read-Host "Presiona [Enter] para continuar"
    return $true
}

# ============================================
# MAIN
# ============================================

function Main {
    Initialize-Logging
    Write-Log "INFO" "Networking Tool Kit v$CurrentVersion started"
    
    # Check for updates (once per day)
    $lastCheckFile = Join-Path $LogDir ".last_update_check"
    $currentTime = [DateTime]::Now.Ticks
    
    if (Test-Path $lastCheckFile) {
        $lastCheck = [DateTime]::FromBinary([long](Get-Content $lastCheckFile))
        $timeDiff = ([DateTime]::Now - $lastCheck).TotalSeconds
    } else {
        $timeDiff = 86401  # Force check
    }
    
    if ($timeDiff -gt 86400) {
        if (Check-ForUpdates) {
            Perform-Update
        }
        $currentTime.ToBinary() | Out-File -FilePath $lastCheckFile -Force
    }
    
    # Main loop
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
            {$_ -eq "U" -or $_ -eq "u"} {
                if (Check-ForUpdates) {
                    Perform-Update
                } else {
                    Write-Host "`n✅ Ya estás en la última versión" -ForegroundColor Green
                    Start-Sleep -Seconds 1
                }
            }
            {$_ -eq "L" -or $_ -eq "l"} { View-Logs }
            {$_ -eq "C" -or $_ -eq "c"} { Clear-Logs }
            "0" {
                Write-Log "INFO" "User exited the tool"
                Write-Host "`n👋 ¡Gracias por usar Networking Tool Kit - Red Mx!" -ForegroundColor Green
                Write-Host "Log guardado en: $LogFile" -ForegroundColor Cyan
                exit 0
            }
            default {
                Write-Host "`n❌ Opción inválida" -ForegroundColor Red
                Write-Log "WARNING" "Invalid option selected: $choice"
                Start-Sleep -Seconds 1
            }
        }
    }
}

# Run the program
Main
