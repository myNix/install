# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_4_8;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "thaddius"; # Define your hostname.
  # hostId needed for zsh
  # cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  # networking.hostId = "47258f0";

  # Select internationalisation properties.
  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment = {

    # NOTE: changes to this take effect on login.
    sessionVariables = {
      EDITOR = "nvim";
      NIXPKGS_ALLOW_UNFREE = "1";
      # Don't create .pyc files.
      PYTHONDONTWRITEBYTECODE = "1";
    };

    shells = [
      "${pkgs.zsh}/bin/zsh"
    ];

    systemPackages = with pkgs; [
      curl
      git
      termite
      (neovim.override { vimAlias = true; })
      zsh-prezto
    ];

  };


  nixpkgs.config = {
    allowUnfree = true;
  };

  programs = {
    zsh.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # List services that you want to enable:

  services = {
    ntp = {
      enable = true;
      servers = [ "server.local" "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" ];
    };

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Enable CUPS to print documents.
    # printing.enable = true;

    # Enable the X11 windowing system.
    xserver = {

      autorun = true; # systemctl start display-manager.service
      enable = true;
      enableTCP = false;
      exportConfiguration = true;
      layout = "us";
      videoDrivers = [ "nvidia" ];
      xkbOptions = "eurosign:e, caps:none";

      desktopManager = {
        xterm.enable = false;
        default = "none";
      };

      windowManager = {
        awesome.enable = true;
        default = "awesome";
      };

    };

  };

  security.sudo.wheelNeedsPassword = false;

  # Define a user account. Don't forget to set a password with `passwd`.
  users.extraUsers.maxter = {
    name = "maxter";
    group = "wheel";
    uid = 1001;
    createHome = true;
    home = "/home/maxter";
    shell = "${pkgs.zsh}/bin/zsh";
  };

  system = {
    # The NixOS release to be compatible with for stateful data such as databases.
    stateVersion = "unstable";
    system.autoUpgrade.enable = true;
    system.autoUpgrade.channel = https://nixos.org/channels/nixos-unstable;
  };
}
