#!/bin/bash

# ============================================
# Networking Tool Kit - Red Mx (Linux v2.1)
# ============================================

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'
BOLD='\033[1m'

# Global paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLS_DIR="$SCRIPT_DIR/tools"
CONFIG_FILE="$SCRIPT_DIR/.config"
LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$LOG_DIR/activity.log"
VERSION_FILE="$SCRIPT_DIR/.version"
CURRENT_VERSION="2.1.0"

# ============================================
# LOGGING FUNCTIONS
# ============================================

init_logging() {
    if [[ ! -d "$LOG_DIR" ]]; then
        mkdir -p "$LOG_DIR"
    fi
    
    if [[ ! -f "$LOG_FILE" ]]; then
        touch "$LOG_FILE"
    fi
    
    # Rotate log if too big (>10MB)
    if [[ -f "$LOG_FILE" ]]; then
        local size=$(du -m "$LOG_FILE" | cut -f1)
        if [[ $size -gt 10 ]]; then
            mv "$LOG_FILE" "$LOG_FILE.old"
            touch "$LOG_FILE"
            log_activity "INFO" "Log rotated (was ${size}MB)"
        fi
    fi
}

log_activity() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local user=$(whoami)
    
    echo "[$timestamp] [$level] [$user] $message" >> "$LOG_FILE"
    
    # Also show on console if DEBUG level
    if [[ "$level" == "DEBUG" && "${ENABLE_DEBUG:-false}" == "true" ]]; then
        echo -e "${YELLOW}[DEBUG] $message${NC}"
    fi
}

# ============================================
# AUTO-UPDATE FUNCTIONS
# ============================================

check_for_updates() {
    log_activity "INFO" "Checking for updates..."
    
    # Check if git is available
    if ! command -v git &> /dev/null; then
        log_activity "WARNING" "Git not installed, cannot auto-update"
        return 1
    fi
    
    # Check if we're in a git repo
    if [[ ! -d "$SCRIPT_DIR/.git" ]]; then
        log_activity "WARNING" "Not a git repository, skipping auto-update"
        return 1
    fi
    
    # Save current branch
    cd "$SCRIPT_DIR"
    local current_branch=$(git branch --show-current)
    
    # Fetch latest changes
    git fetch origin &> /dev/null
    
    # Check if there are updates
    local local_hash=$(git rev-parse HEAD)
    local remote_hash=$(git rev-parse origin/$current_branch)
    
    if [[ "$local_hash" != "$remote_hash" ]]; then
        log_activity "INFO" "Updates available! Local: $local_hash, Remote: $remote_hash"
        return 0
    else
        log_activity "DEBUG" "Already up to date"
        return 1
    fi
}

perform_update() {
    echo -e "\n${YELLOW}🔄 Actualizaciones disponibles para Networking Tool Kit${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "Versión actual: ${GREEN}$CURRENT_VERSION${NC}"
    
    # Get latest version from remote
    cd "$SCRIPT_DIR"
    git fetch origin &> /dev/null
    
    # Show changelog
    echo -e "\n${YELLOW}📝 Cambios encontrados:${NC}"
    git log --oneline HEAD..origin/main --max-count=5 2>/dev/null | while read line; do
        echo -e "  ${CYAN}•${NC} $line"
    done
    
    echo -e "\n${YELLOW}¿Deseas actualizar ahora? [s/N]: ${NC}"
    read -r answer
    
    if [[ "$answer" =~ ^[Ss]$ ]]; then
        echo -e "${GREEN}▶ Actualizando...${NC}"
        log_activity "INFO" "Starting update process"
        
        # Stash any local changes
        git stash push -m "auto-stash-before-update" &> /dev/null
        
        # Pull changes
        if git pull origin main &> /dev/null; then
            echo -e "${GREEN}✅ Actualización completada con éxito!${NC}"
            log_activity "INFO" "Update completed successfully"
            
            # Update version
            echo "$CURRENT_VERSION" > "$VERSION_FILE"
            
            echo -e "${YELLOW}⚠️ Se recomienda reiniciar la herramienta para aplicar los cambios${NC}"
            echo -e "${CYAN}Presiona Enter para continuar...${NC}"
            read
            
            # Reload the script
            exec "$0"
        else
            echo -e "${RED}❌ Error durante la actualización${NC}"
            log_activity "ERROR" "Update failed"
            git stash pop &> /dev/null
            sleep 2
        fi
    else
        echo -e "${YELLOW}Actualización cancelada${NC}"
        log_activity "INFO" "Update cancelled by user"
        sleep 1
    fi
}

# ============================================
# UI FUNCTIONS
# ============================================

show_banner() {
    clear
    echo -e "${RED}╔════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}      ${CYAN}${BOLD}🔥 RED MX NETWORK TOOL KIT 🔥${NC}      ${RED}║${NC}"
    echo -e "${RED}║${NC}    ${GREEN}Herramientas de red profesional${NC}     ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}          Versión $CURRENT_VERSION - Linux${NC}"
    
    # Show last update info
    if [[ -f "$VERSION_FILE" ]]; then
        local last_version=$(cat "$VERSION_FILE")
        if [[ "$last_version" != "$CURRENT_VERSION" ]]; then
            echo -e "${GREEN}✨ Actualizado recientemente a v$CURRENT_VERSION${NC}"
        fi
    fi
    echo ""
}

show_menu() {
    echo -e "${CYAN}┌─────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC}  ${BOLD}CATEGORÍA${NC}                         ${CYAN}│${NC}"
    echo -e "${CYAN}├─────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}1.${NC} Diagnóstico de red              ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}    ${BLUE}1.1${NC} Ping                           ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}    ${BLUE}1.2${NC} Traceroute                     ${CYAN}│${NC}"
    echo -e "${CYAN}├─────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}2.${NC} Información de red              ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}    ${BLUE}2.1${NC} Netstat                        ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}    ${BLUE}2.2${NC} Nslookup                       ${CYAN}│${NC}"
    echo -e "${CYAN}├─────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}3.${NC} Resolución de nombres           ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}    ${BLUE}3.1${NC} Whois                          ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}    ${BLUE}3.2${NC} Telnet                         ${CYAN}│${NC}"
    echo -e "${CYAN}├─────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}4.${NC} Conexión remota                 ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}    ${BLUE}4.1${NC} Cliente SSH                    ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}    ${BLUE}4.2${NC} Escaneo de puertos             ${CYAN}│${NC}"
    echo -e "${CYAN}├─────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}5.${NC} Transferencia de archivos       ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}    ${BLUE}5.1${NC} Descarga (wget/curl)           ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}    ${BLUE}5.2${NC} Monitoreo de red               ${CYAN}│${NC}"
    echo -e "${CYAN}├─────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC}  ${MAGENTA}U.${NC} Buscar actualizaciones          ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${MAGENTA}L.${NC} Ver logs de actividad           ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${MAGENTA}C.${NC} Limpiar logs                   ${CYAN}│${NC}"
    echo -e "${CYAN}├─────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC}  ${RED}0.${NC} Salir                             ${CYAN}│${NC}"
    echo -e "${CYAN}└─────────────────────────────────────┘${NC}"
    echo -ne "${YELLOW}➤ Selecciona una opción (ej: 1.1, U, L, C, 0): ${NC}"
}

# ============================================
# UTILITY FUNCTIONS
# ============================================

view_logs() {
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}📋 Últimas 50 líneas del log de actividad:${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    
    if [[ -f "$LOG_FILE" ]]; then
        tail -50 "$LOG_FILE" | while read line; do
            if [[ $line =~ "ERROR" ]]; then
                echo -e "${RED}$line${NC}"
            elif [[ $line =~ "WARNING" ]]; then
                echo -e "${YELLOW}$line${NC}"
            elif [[ $line =~ "INFO" ]]; then
                echo -e "${GREEN}$line${NC}"
            else
                echo "$line"
            fi
        done
    else
        echo -e "${YELLOW}No hay logs aún.${NC}"
    fi
    
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "Presiona [Enter] para continuar..."
}

clear_logs() {
    echo -e "\n${YELLOW}⚠️ ¿Estás seguro de que quieres limpiar todos los logs? [s/N]: ${NC}"
    read -r answer
    
    if [[ "$answer" =~ ^[Ss]$ ]]; then
        > "$LOG_FILE"
        log_activity "INFO" "Logs cleared by user"
        echo -e "${GREEN}✅ Logs limpiados correctamente${NC}"
    else
        echo -e "${YELLOW}Operación cancelada${NC}"
    fi
    sleep 1
}

run_tool() {
    local category=$1
    local tool=$2
    local tool_file=""
    
    case $category-$tool in
        "1-1") tool_file="01_ping.sh" ;;
        "1-2") tool_file="02_traceroute.sh" ;;
        "2-1") tool_file="03_netstat.sh" ;;
        "2-2") tool_file="04_nslookup.sh" ;;
        "3-1") tool_file="05_whois.sh" ;;
        "3-2") tool_file="06_telnet.sh" ;;
        "4-1") tool_file="07_ssh.sh" ;;
        "4-2") tool_file="08_port_scanner.sh" ;;
        "5-1") tool_file="09_download.sh" ;;
        "5-2") tool_file="10_monitor.sh" ;;
        *) return 1 ;;
    esac
    
    log_activity "INFO" "Executing tool: $tool_file"
    
    local tool_path="$TOOLS_DIR/$tool_file"
    
    if [[ -f "$tool_path" ]]; then
        echo -e "\n${GREEN}▶ Ejecutando herramienta...${NC}\n"
        sleep 1
        bash "$tool_path"
        log_activity "INFO" "Tool execution completed: $tool_file"
    else
        echo -e "\n${RED}❌ Error: Herramienta no encontrada en $tool_path${NC}"
        log_activity "ERROR" "Tool not found: $tool_file"
    fi
    
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "Presiona [Enter] para continuar..."
}

# ============================================
# MAIN
# ============================================

main() {
    # Initialize
    init_logging
    log_activity "INFO" "Networking Tool Kit v$CURRENT_VERSION started"
    
    # Check for updates (once per day)
    if [[ -f "$CONFIG_FILE" ]] && grep -q "AUTO_UPDATE=true" "$CONFIG_FILE"; then
        local last_check_file="$LOG_DIR/.last_update_check"
        local current_time=$(date +%s)
        local last_check=0
        
        if [[ -f "$last_check_file" ]]; then
            last_check=$(cat "$last_check_file")
        fi
        
        # Check every 24 hours (86400 seconds)
        if [[ $((current_time - last_check)) -gt 86400 ]] || [[ ! -f "$last_check_file" ]]; then
            if check_for_updates; then
                perform_update
            fi
            echo "$current_time" > "$last_check_file"
        fi
    fi
    
    # Main loop
    while true; do
        show_banner
        show_menu
        read -r choice
        
        case $choice in
            1.1|1.1|"1.1") run_tool 1 1 ;;
            1.2|"1.2") run_tool 1 2 ;;
            2.1|"2.1") run_tool 2 1 ;;
            2.2|"2.2") run_tool 2 2 ;;
            3.1|"3.1") run_tool 3 1 ;;
            3.2|"3.2") run_tool 3 2 ;;
            4.1|"4.1") run_tool 4 1 ;;
            4.2|"4.2") run_tool 4 2 ;;
            5.1|"5.1") run_tool 5 1 ;;
            5.2|"5.2") run_tool 5 2 ;;
            [Uu]) 
                if check_for_updates; then
                    perform_update
                else
                    echo -e "\n${GREEN}✅ Ya estás en la última versión${NC}"
                    sleep 1
                fi
                ;;
            [Ll]) view_logs ;;
            [Cc]) clear_logs ;;
            0|"0"|"salir"|"exit"|"quit")
                log_activity "INFO" "User exited the tool"
                echo -e "\n${GREEN}👋 ¡Gracias por usar Networking Tool Kit - Red Mx!${NC}"
                echo -e "${CYAN}Log guardado en: $LOG_FILE${NC}"
                exit 0
                ;;
            *)
                echo -e "\n${RED}❌ Opción inválida${NC}"
                log_activity "WARNING" "Invalid option selected: $choice"
                sleep 1
                ;;
        esac
    done
}

# Run the program
main
