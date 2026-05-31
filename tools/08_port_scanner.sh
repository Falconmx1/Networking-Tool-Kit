#!/bin/bash
read -p "🎯 Enter target IP: " target
read -p "🔢 Enter port range (e.g., 20-80): " ports
nc -zv "$target" $ports 2>&1 | grep -v "failed"
