#!/bin/bash
read -p "Ingresa la dirección IP o dominio a hacer ping: " target
ping -c 4 "$target"
