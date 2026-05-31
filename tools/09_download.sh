#!/bin/bash
read -p "⬇️ Enter URL to download: " url
read -p "📁 Save as: " filename
wget -O "$filename" "$url"
