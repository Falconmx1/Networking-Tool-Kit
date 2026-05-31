#!/bin/bash
read -p "🌐 Enter IP or domain: " target
ping -c 4 "$target"
