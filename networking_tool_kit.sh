#!/bin/bash

# Colores para el banner
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # Sin color

show_banner() {
    clear
    echo -e "${RED}==================================${NC}"
    echo -e "${CYAN}        🔧 RED MX TOOL KIT 🔧        ${NC}"
    echo -e "${RED}==================================${NC}"
}

show_menu() {
    echo "1. Herramientas de diagnóstico"
    echo "2. Herramientas de información de red"
    echo "3. Herramientas de resolución de nombres"
    echo "4. Herramientas de conexión remota"
    echo "5. Herramientas de escaneo"
    echo "6. Herramientas de transferencia"
    echo "7. Herramientas de monitoreo"
    echo "8. Herramientas de configuración"
    echo "9. Utilidades generales"
    echo "10. Salir"
    echo -n "Selecciona una opción (1-10): "
}

run_tool() {
    local tool_path="tools/$1.sh"
    if [[ -f "$tool_path" ]]; then
        bash "$tool_path"
    else
        echo "Herramienta no encontrada: $tool_path"
    fi
    echo -n "Presiona Enter para continuar..."
    read
}

while true; do
    show_banner
    show_menu
    read opcion
    case $opcion in
        1) run_tool "01_ping" ;;
        2) run_tool "02_traceroute" ;;
        3) run_tool "03_netstat" ;;
        4) run_tool "04_nslookup" ;;
        5) run_tool "05_whois" ;;
        6) run_tool "06_telnet" ;;
        7) run_tool "07_ssh" ;;
        8) run_tool "08_port_scanner" ;;
        9) run_tool "09_download" ;;
        10) echo "Saliendo..."; exit 0 ;;
        *) echo "Opción inválida"; sleep 1 ;;
    esac
done
