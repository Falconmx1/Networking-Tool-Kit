#!/bin/bash
read -p "📍 Enter IP or domain: " target
traceroute "$target"
