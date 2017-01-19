{ config, pkgs, ... }:

{
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.firefox.enableAdobeFlash = true;

     hardware = {
       bluetooth.enable = false;
       pulseaudio = {
       enable = true;
       package = pkgs.pulseaudioFull;
       support32Bit = true;
     };
  cpu.intel.updateMicrocode = true;
  opengl = {
      driSupport32Bit = true;
      extraPackages = [ pkgs.vaapiIntel ];
  };
  trackpoint = {
      enable = true;
      sensitivity = 200;
      emulateWheel = true;
  };
     };

     fileSystems."/" = {
  device = "/dev/vg/root";
  label = "root";
  fsType = "ext4";
  options = [ "noatime" "nodiratime" "discard" ];
     };

     fileSystems."/boot" = {
       device = "/dev/disk/by-label/BOOT";
       mountPoint = "/boot";
     };

     swapDevices = [
       {
  device = "/dev/vg/swap";
       }
     ];

     boot = {
  vesa = false;

  kernelPackages = pkgs.linuxPackages_latest;

  initrd = {
      luks = {
                      cryptoModules = ["aes" "xts" "sha512" "sha256" ];
        devices = [
   {
     allowDiscards = true;
     name = "root";
     device = "/dev/sda3";
     preLVM = true;
   }
        ];
      };
      kernelModules = [ "xhci_hcd" "ehci_pci" "ahci" "usb_storage" "aesni-intel" "fbcon" "i915" ];
      availableKernelModules = [ "scsi_wait_scan" ];
  };
  kernelModules = [ "kvm-intel" "msr" "bbswitch" ];
  blacklistedKernelModules = [ "snd_pcsp" "pcspkr" ];

  kernelParams = [
      "i915.enable_ips=0"
  ];
  extraModprobeConfig = ''
      options snd_hda_intel mode=auto power_save=1 index=1
  '';


  loader = {

      efi.canTouchEfiVariables = true;

      grub = {
   enable = true;
   version = 2;
   efiSupport = true;
   gfxmodeEfi = "1024*768";
   device = "nodev";
   memtest86.enable = false;
   configurationLimit = 50;
            };
        };
    };

    time = {
        timeZone = "Europe/Paris";
    };

    networking = {
        firewall = {
            enable = true;
            allowPing = false;
        };
        hostName = "maxime-scality";
	networkmanager.enable = true;
    };

    #i18n = {
    #    consoleKeyMap = "en";
    #    defaultLocale = "en_US.UTF-8";
    #};

    environment.systemPackages = with pkgs; [
        # Shells
        zsh

        # Editors
        (neovim.override { vimAlias = true; })
 atom

        # Browsers
        firefoxWrapper

        git

        dmenu
 i3status
 i3lock

        rxvt_unicode
 termite
 enlightenment.terminology

        arandr
        acpi
        file
        gparted
        htop
        pciutils
        tree
        wget
        curl

        nox
        python27
        python35

        # Others
        xlibs.xf86videointel
        vaapiIntel

 # rst editor
 # retext
 go
    ];

    services = {
        fail2ban = {
            enable = true;
            jails.ssh-iptables = ''
                enable = true
            '';
        };

        acpid = {
            enable = true;
        };

        dbus = {
            enable = true;
        };

        devmon = {
            enable = true;
        };

        xserver = {
            enable = true;
            layout = "en";
            displayManager.slim.enable = true;
	    displayManager.sessionCommands = "${pkgs.networkmanagerapplet}/bin/nm-applet &";

            videoDrivers = [ "intel" ];

            synaptics = {
                enable = true;
            };

            windowManager = {
                i3 = {
                    enable = true;
                };
                default = "i3";
            };
        };
    };

    powerManagement = {
        enable = true;
        cpuFreqGovernor = "ondemand";
        scsiLinkPolicy = "max_performance";
    };

    fonts = {
        enableFontDir = true;
        enableGhostscriptFonts = true;
        fonts = with pkgs; [
            corefonts
            dejavu_fonts
            inconsolata
            liberation_ttf
            terminus_font
            ttf_bitstream_vera
            vistafonts
        ];
    };

    # TODO: enable ecryptfs
    #security.pam.enableEcryptfs = true;

    users.extraUsers = {
        maxter = {
            description = "Maxime Vaude";
            uid = 1000;
            extraGroups = [
                "adm"
                "audio"
                "cdrom"
                "dialout"
                "docker"
                "libvirtd"
                "networkmanager"
                "plugdev"
                "scanner"
                "systemd-journal"
                "tracing"
                "transmission"
                "tty"
                "usbtmc"
                "vboxusers"
                "video"
                "wheel"
                "wireshark"
            ];
            isNormalUser = true;
            initialPassword = "passit";
        };
    };
    virtualisation = {
     virtualbox.host.enable = true;
     docker.enable = true;
     libvirtd.enable = true;
    };
}
