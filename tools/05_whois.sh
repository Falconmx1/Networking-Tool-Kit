#!/bin/bash
read -p "📋 Enter domain or IP: " target
whois "$target"
