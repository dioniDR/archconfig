# ✅ Instalación funcional de Arch Linux en VirtualBox (Guía probada)

Esta guía documenta paso a paso el proceso que nos funcionó para instalar Arch Linux correctamente en una máquina virtual VirtualBox.

---

## ✅ Pre-requisitos

* ISO de Arch Linux reciente (desde [archlinux.org](https://archlinux.org))
* VirtualBox (con UEFI habilitado si se quiere probar Hyprland luego)

---

## 🔄 Primeros pasos desde el LiveCD

```bash
loadkeys la-latin1        # teclado en español latino
ping archlinux.org        # verificar conexión
```

---

## 📁 Particionado con GPT usando `cfdisk`

```bash
cfdisk /dev/sda
# Elegir "gpt"
# Crear:
#  - /boot/efi de tipo EFI System (512M)
#  - / de tipo Linux filesystem (resto del disco)
```

---

## 🔒 Formateo y montaje

```bash
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

mount /dev/sda2 /mnt
mkdir /mnt/boot
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
```

---

## 🔀 Instalación base

```bash
pacstrap -K /mnt base base-devel linux linux-firmware nano networkmanager grub efibootmgr
```

---

## 🌐 Fstab y chroot

```bash
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

---

## 📆 Configuraciones iniciales

```bash
echo archvm > /etc/hostname
ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
hwclock --systohc
```

Editar locales:

```bash
nano /etc/locale.gen
# Descomentar:
#   en_US.UTF-8 UTF-8
#   es_MX.UTF-8 UTF-8
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

---

## 🔑 Crear usuario y contraseña

```bash
passwd     # root
useradd -m -G wheel dioni
passwd dioni
EDITOR=nano visudo   # Descomentar: %wheel ALL=(ALL:ALL) ALL
```

---

## 🌐 Red y bootloader

```bash
systemctl enable NetworkManager
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

---

## ⚖️ Final

```bash
exit
umount -R /mnt
reboot
```

**Nota:** quitar el ISO de VirtualBox antes de reiniciar.

---

## 🚀 Login

* Usuario: `dioni`
* Contraseña: (la que elegiste)

---

Puedes continuar luego con el entorno de escritorio e instalación de Hyprland (ver otro README).
