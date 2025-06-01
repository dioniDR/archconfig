#!/bin/bash
set -e

echo "🔧 Escaneando redes Wi-Fi disponibles..."
rfkill unblock wifi
ip link set wlan0 up 2>/dev/null || true
iwctl station wlan0 scan
sleep 2
iwctl station wlan0 get-networks

echo ""
read -p '📶 Nombre de la red Wi-Fi (SSID): ' ssid
read -s -p '🔑 Contraseña: ' psk
echo ""

# Conectar con iwctl
echo "⏳ Conectando a $ssid..."
iwctl --passphrase "$psk" station wlan0 connect "$ssid"

# Esperar IP
echo "🔄 Esperando asignación de IP..."
sleep 3
ping -c 3 archlinux.org && echo "✅ Conectado a internet." || echo "❌ Error de conexión."

