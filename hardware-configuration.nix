# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ata_piix" "usbhid" "sd_mod" ];
  boot.initrd.luks.cryptoModules = ["aes" "sha256" "sha1" "cbc"];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { mountPoint = "/";
      device = "/dev/mapper/root";
      fsType = "ext4";
      options = "noatime,nodiratime,discard";
    };

  boot.initrd.luks.devices = [{
      name = "root";
      device = "/dev/mapper/thaddius-lvroot";
      allowDiscards = true;
  }];

  fileSystems."/boot" =
    { mountPoint = "/boot";
      device = "/dev/sdb3";
      fsType = "vfat";
    };

  swapDevices = [ ];

  nix = {
    extraOptions = ''
      build-cores = 6;
    '';
    maxJobs = lib.mkDefault 12;
  };
}