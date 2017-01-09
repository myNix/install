rm -rf /mnt/etc/nixos/*
cp *.nix /mnt/etc/nixos/
nixos-install -I nixkgs=/mnt/etc/nixos/nixpkgs-channels/
