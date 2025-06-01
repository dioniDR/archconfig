#!/bin/bash

echo "📁 Creando carpetas de configuración..."
mkdir -p ~/.config/hypr
mkdir -p ~/.config/waybar
mkdir -p ~/.config/kitty
mkdir -p ~/.config/dunst
mkdir -p ~/.config/rofi
mkdir -p ~/Pictures

echo "🎨 Descargando fondo personalizado..."
curl -Lo ~/Pictures/wall.png https://raw.githubusercontent.com/dioniDR/archconfig/main/wall.png

echo "📝 Escribiendo hyprland.conf..."
cat > ~/.config/hypr/hyprland.conf <<EOF
# Módulos básicos
exec-once = waybar &
exec-once = dunst &
exec-once = kitty

# Monitor
monitor=,preferred,auto,1

# Variables
\$mod = SUPER

# Atajos
bind = \$mod, RETURN, exec, kitty
bind = \$mod, Q, killactive
bind = \$mod, D, exec, rofi -show drun
bind = \$mod, F, fullscreen, 1
bind = \$mod, V, togglefloating
bind = \$mod, H, movefocus, l
bind = \$mod, L, movefocus, r
bind = \$mod, K, movefocus, u
bind = \$mod, J, movefocus, d
EOF

echo "📝 Escribiendo hyprpaper.conf..."
cat > ~/.config/hypr/hyprpaper.conf <<EOF
preload = ~/Pictures/wall.png
wallpaper = ,~/Pictures/wall.png
EOF

echo "✅ Configuración lista. Puedes iniciar Hyprland con:"
echo "Hyprland"
