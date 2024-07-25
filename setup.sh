#!/bin/bash

rm -v /etc/makepkg.conf
rm -v /etc/pacman.conf

FOLDER="$1"

if [ "$FOLDER" != "clanged" ] && [ "$FOLDER" != "gcced" ]; then
    echo "Wrong folder"
    exit 1
fi

cd $FOLDER

# Copy new configuration files
cp makepkg.conf /etc/
cp pacman.conf /etc/

# Update packages and initialize keys
pacman -Syyu --noconfirm archlinux-keyring reflector
pacman-key --init
pacman-key --populate

# Update mirror list
reflector --ipv4 --ipv6 -l 10 -f 10 -a 10 --protocol http,https --sort rate --save /etc/pacman.d/mirrorlist

# Install additional packages
pacman -Syyuu --noconfirm --needed git base-devel aria2-git

# Copy entrypoint script
cp entrypoint.sh /bin/build.sh

# Set entrypoint script as executable
chmod +x /bin/build.sh