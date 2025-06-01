#!/bin/bash
set -e

# Teclado y conexión
loadkeys la-latin1
ping -c 3 archlinux.org

# Particionar disco
sgdisk -Z /dev/sda
sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI System" /dev/sda
sgdisk -n 2:0:0 -t 2:8300 -c 2:"Linux Root" /dev/sda

# Formatear particiones
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

# Montar particiones
mount /dev/sda2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

# Instalar base
pacstrap -K /mnt base base-devel linux linux-firmware nano networkmanager grub efibootmgr

# Fstab y chroot
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt <<EOF

# Hostname
echo archvm > /etc/hostname

# Zona horaria y reloj
ln -sf /usr/share/zoneinfo/America/Denver /etc/localtime
hwclock --systohc

# Locales
sed -i '/en_US.UTF-8/s/^#//' /etc/locale.gen
sed -i '/es_MX.UTF-8/s/^#//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=la-latin1" > /etc/vconsole.conf

# Usuario
useradd -m -G wheel dioni
echo root:dioni | chpasswd
echo dioni:dioni | chpasswd
sed -i '/%wheel ALL=(ALL:ALL) ALL/s/^# //' /etc/sudoers

# Red y GRUB
systemctl enable NetworkManager
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

EOF

# Finalizar
umount -R /mnt
echo "✅ Instalación finalizada. Ejecuta: reboot"
