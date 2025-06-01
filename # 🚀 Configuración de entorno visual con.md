# 🚀 Configuración de entorno visual con Hyprland (Guía funcional)

Esta guía resume todo lo que se realizó para que Hyprland funcione correctamente en una máquina Arch instalada sobre VirtualBox.

---

## 🚪 Pre-requisitos

* Instalación funcional de Arch Linux
* Entorno UEFI habilitado
* Conexión a internet estable

---

## 🔄 Actualización de mirrors (por errores 404)

```bash
sudo pacman -S reflector
sudo reflector --country "United States" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syyu
```

---

## 🚪 Instalación de Hyprland y componentes visuales

```bash
sudo pacman -S hyprland waybar kitty dunst rofi-wayland hyprpaper
```

> Si se producen errores por paquetes no encontrados, asegurarse de que el mirrorlist esté actualizado correctamente.

---

## 🔍 Verificación de instalaciones

```bash
command -v Hyprland kitty rofi waybar dunst hyprpaper
```

Si todos devuelven rutas (/usr/bin/...), están correctamente instalados.

---

## 🔺 Estructura de carpetas de configuración

```bash
mkdir -p ~/.config/hypr
mkdir -p ~/.config/hypr/scripts
mkdir -p ~/.config/rofi
echo "" > ~/.config/hypr/hyprland.conf
```

---

## 🗃️ Archivo hyprland.conf mínimo funcional

```ini
monitor=,preferred,auto,1

$mod=SUPER

bind=$mod,RETURN,exec,kitty
bind=$mod,D,exec,rofi -show drun
bind=$mod,Q,killactive
bind=$mod,F,fullscreen
bind=$mod,V,togglefloating

bind=$mod,H,movefocus,l
bind=$mod,L,movefocus,r
bind=$mod,K,movefocus,u
bind=$mod,J,movefocus,d

exec-once = waybar &
exec-once = dunst &
exec-once = kitty &
```

> Nota: **no ejecutar hyprpaper sin tener fondo y archivo de config**, puede crashear Hyprland.

---

## 📷 Fondo personalizado

Si se desea un fondo inicial:

```bash
mkdir -p ~/Pictures
curl -Lo ~/Pictures/wall.png https://raw.githubusercontent.com/dioniDR/archconfig/main/wall.png
```

### hyprpaper.conf (opcional)

```ini
preload = ~/Pictures/wall.png
wallpaper = ,~/Pictures/wall.png
```

Ubicarlo en: `~/.config/hypr/hyprpaper.conf`

---

## 🔌 Ejecutar Hyprland

```bash
Hyprland
```

---

## 📢 Sobre errores comunes

### ❌ "core dumped"

* Causa probable: ejecutar `hyprpaper` sin Wayland activo
* Solución: comentar temporalmente `exec-once = hyprpaper &`

### ⚠️ "404 al instalar paquetes"

* Usar `reflector` para renovar mirrors antes de `pacman -S`

---

## ✅ Resultado esperado

* Barra superior funcionando (`waybar`)
* Terminal (`kitty`) y lanzador (`rofi`) accesibles
* Teclas Super + D, Super + Q funcionales

---

Para automatizar la configuración, ver script `setup-hypr.sh`
