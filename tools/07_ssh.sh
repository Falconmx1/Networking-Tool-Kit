#!/bin/bash
read -p "🔐 Enter user@host: " user_host
ssh "$user_host"
