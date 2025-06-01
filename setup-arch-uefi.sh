#!/bin/bash
set -e

echo "🔧 Preparando teclado e internet..."
loadkeys la-latin1
rfkill unblock wifi || true
ip link set wlan0 up 2>/dev/null || true
ping -c 3 archlinux.org || echo "⚠️ Puede que no tengas red aún (continuamos)"

echo "📦 Formateando disco y creando particiones..."
sgdisk -Z /dev/sda
sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI System" /dev/sda
sgdisk -n 2:0:0 -t 2:8300 -c 2:"Linux Root" /dev/sda

mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

mount /dev/sda2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

echo "🚀 Instalando sistema base con soporte de red robusto..."
pacstrap -K /mnt base base-devel linux linux-firmware nano networkmanager iwd grub efibootmgr

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt <<EOF

echo archvm > /etc/hostname
ln -sf /usr/share/zoneinfo/America/Denver /etc/localtime
hwclock --systohc

# Locales
sed -i '/en_US.UTF-8/s/^#//' /etc/locale.gen
sed -i '/es_MX.UTF-8/s/^#//' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo KEYMAP=la-latin1 > /etc/vconsole.conf

# Crear usuario
useradd -m -G wheel dioni
echo root:dioni | chpasswd
echo dioni:dioni | chpasswd
sed -i '/%wheel ALL=(ALL:ALL) ALL/s/^# //' /etc/sudoers

# Red: ambos servicios habilitados
systemctl enable NetworkManager
systemctl enable iwd

# GRUB para UEFI
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

EOF

umount -R /mnt
echo "✅ Instalación lista. Puedes reiniciar con: reboot"
