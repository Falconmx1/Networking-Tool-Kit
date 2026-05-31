# 🌐 Networking Tool Kit - Red Mx

**Networking Tool Kit** es una herramienta de línea de comandos diseñada para facilitar tareas comunes de administración de redes en entornos **Windows** y **Linux**. Presenta un menú interactivo con **10 categorías** y **2 herramientas por categoría**, ideal para técnicos, estudiantes y entusiastas del networking.

## 🚀 Características

- 🖥️ Compatible con **Windows** (PowerShell) y **Linux** (Bash)
- 🎨 Banner estilizado con **"Red Mx"**
- 📋 Menú principal con 10 opciones, cada una con 2 herramientas
- ⚡ Ejecución rápida sin dependencias complejas
- 🛠️ Herramientas incluidas:
  - Ping, Traceroute, Netstat, Nslookup, Whois, Telnet, SSH (cliente básico), Escaneo de puertos, Descarga de archivos (wget/curl), Monitoreo de red básico

## 📂 Estructura del proyecto
Networking-Tool-Kit/
├── README.md
├── LICENSE
├── .gitignore
├── networking_tool_kit.sh (Linux)
├── networking_tool_kit.ps1 (Windows)
└── tools/
├── ping_tool.sh
├── traceroute_tool.sh
├── port_scanner.sh
└── ... (demás módulos)


## 🧪 Requisitos

### Linux
- Bash
- `ping`, `traceroute`, `netstat`, `nslookup`, `whois`, `telnet`, `ssh`, `nc` (netcat), `wget`/`curl`

### Windows
- PowerShell 5.1 o superior
- Acceso a `Test-Connection`, `tracert`, `nslookup`, `netstat`, `telnet` (opcional)

## 📦 Instalación

```bash
git clone https://github.com/Falconmx1/Networking-Tool-Kit.git
cd Networking-Tool-Kit
chmod +x networking_tool_kit.sh  # Linux

🕹️ Uso
Linux
./networking_tool_kit.sh

Windows
.\networking_tool_kit.ps1
