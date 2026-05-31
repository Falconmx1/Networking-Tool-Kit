#!/bin/bash

# ============================================
# Networking Tool Kit - Red Mx (Linux Version)
# ============================================

# Colors for UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Global variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLS_DIR="$SCRIPT_DIR/tools"

# Function to show banner
show_banner() {
    clear
    echo -e "${RED}╔════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}      ${CYAN}${BOLD}🔥 RED MX NETWORK TOOL KIT 🔥${NC}      ${RED}║${NC}"
    echo -e "${RED}║${NC}    ${GREEN}Herramientas de red profesional${NC}     ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}          Versión 2.0 - Linux${NC}\n"
}

# Function to show main menu
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
    echo -e "${CYAN}│${NC}  ${RED}0.${NC} Salir                             ${CYAN}│${NC}"
    echo -e "${CYAN}└─────────────────────────────────────┘${NC}"
    echo -ne "${YELLOW}➤ Selecciona una opción (ej: 1.1 o 0): ${NC}"
}

# Function to run a specific tool
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
    
    local tool_path="$TOOLS_DIR/$tool_file"
    
    if [[ -f "$tool_path" ]]; then
        echo -e "\n${GREEN}▶ Ejecutando herramienta...${NC}\n"
        sleep 1
        bash "$tool_path"
    else
        echo -e "\n${RED}❌ Error: Herramienta no encontrada en $tool_path${NC}"
        echo -e "${YELLOW}💡 Asegúrate de que los archivos estén en la carpeta 'tools/'${NC}"
    fi
    
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "Presiona [Enter] para continuar..."
}

# Function to check dependencies
check_dependencies() {
    local deps=("ping" "traceroute" "netstat" "nslookup" "whois" "telnet" "ssh" "nc" "wget" "curl")
    local missing=()
    
    echo -e "\n${YELLOW}🔍 Verificando dependencias...${NC}"
    for cmd in "${deps[@]}"; do
        if command -v "$cmd" &> /dev/null; then
            echo -e "  ${GREEN}✓${NC} $cmd"
        else
            echo -e "  ${RED}✗${NC} $cmd"
            missing+=("$cmd")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        echo -e "\n${RED}⚠ Faltan dependencias: ${missing[*]}${NC}"
        echo -e "${YELLOW}Instálalas con: sudo apt install ${missing[*]}${NC}"
        echo -e "${YELLOW}O ejecuta: ./install.sh${NC}\n"
        read -p "Presiona [Enter] para continuar de todas formas..."
    fi
}

# Function to validate tools directory
validate_tools() {
    if [[ ! -d "$TOOLS_DIR" ]]; then
        echo -e "${RED}❌ Error: No se encuentra la carpeta 'tools/'${NC}"
        echo -e "${YELLOW}💡 Crea la carpeta y coloca los scripts de herramientas allí.${NC}"
        exit 1
    fi
}

# Main execution
main() {
    validate_tools
    check_dependencies
    
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
            0|"0"|"salir"|"exit"|"quit")
                echo -e "\n${GREEN}👋 ¡Gracias por usar Networking Tool Kit - Red Mx!${NC}"
                exit 0
                ;;
            *)
                echo -e "\n${RED}❌ Opción inválida. Usa el formato 'número.número' (ej: 1.1)${NC}"
                sleep 2
                ;;
        esac
    done
}

# Run the program
main
