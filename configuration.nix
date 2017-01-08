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
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.

  # Select internationalisation properties.
  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    curl
    git
    nvim
    rxvt_unicode
    wget
    zsh
  ]);

  nixpkgs.config = {
    allowUnfree = true;

    chromium = {
      enablePepperFlash = true;
      enablePepperPDF = true;
    };
  };

  programs = {
    bash.enableCompletion = true;
    zsh.enable = true;
  };

  # NOTE: changes to this take effect on login.
  environment.sessionVariables = {
    EDITOR = "vim";
    NIXPKGS_ALLOW_UNFREE = "1";
    # Don't create .pyc files.
    PYTHONDONTWRITEBYTECODE = "1";
  };

  environment.shells = [
    "${pkgs.zsh}/bin/zsh"
  ];

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # List services that you want to enable:

  services.ntp = {
    enable = true;
    servers = [ "server.local" "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" ];
  };

  security.sudo.wheelNeedsPassword = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    autorun = true; # systemctl start display-manager.service
    enable = true;
    enableTCP = false;
    exportConfiguration = true;
    layout = "us";
    videoDrivers = [ "nvidia" ];
    xkbOptions = "eurosign:e, caps:none";

    desktopManager = {
      xterm.enable = true;
      default = "none";
    };
    windowManager = {
      awesome.enable = true;
      default = "awesome";
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Define a user account. Don't forget to set a password with `passwd`.
  users.extraUsers.maxter = {
    name = "maxter";
    group = "wheel";
    uid = 1001;
    createHome = true;
    home = "/home/maxter";
    shell = "${pkgs.zsh}/bin/zsh";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";

}