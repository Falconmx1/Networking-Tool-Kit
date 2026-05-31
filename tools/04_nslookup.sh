#!/bin/bash
read -p "🔍 Enter domain: " domain
nslookup "$domain"
