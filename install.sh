#!/usr/bin/env bash

sgdisk -og $1
sgdisk -n 1:2048:4095 -c 1:"BIOS Boot Partition" -t 1:ef02 $1
sgdisk -n 2:4096:413695 -c 2:"EFI System Partition" -t 2:ef00 $1
sgdisk -n 3:413696:823295 -c 3:"Linux /boot" -t 3:8300 $1
ENDSECTOR=`sgdisk -E $1`
sgdisk -n 4:823296:$ENDSECTOR -c 4:"Linux LVM" -t 4:8e00 $1
sgdisk -p $1

pvcreate $14
vgcreate $2 $14
lvcreate -L 50G -n lvroot $2
lvcreate -L 5G -n swap $2
lvcreate -L 5G -n tmp $2
lvcreate -l 100%FREE -n home $2

cryptsetup luksFormat -c aes-xts-plain64 -s 512 /dev/mapper/$2-lvroot
cryptsetup open /dev/mapper/$2-lvroot root
mkfs.ext4 -L nixos /dev/mapper/root
mount /dev/mapper/root /mnt
