#!/bin/bash
read -p "📞 Enter host: " host
read -p "🔌 Enter port: " port
telnet "$host" "$port"
