#!/bin/bash
read -p "📈 Enter interface (e.g., eth0): " iface
watch -n 1 "ifconfig $iface | grep -E 'RX|TX'"
