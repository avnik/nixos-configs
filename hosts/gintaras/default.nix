# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ../../users.nix
      ../../common/common.nix
      ../../roles/console.nix
      ../../roles/desktop.nix
      ../../roles/X11.nix
      ../../common/pipewire.nix
      ../../common/fonts.nix
      ../../roles/chats.nix
      ../../roles/gaming.nix
      ../../roles/printing.nix
    ];

  # Don't use the gummiboot efi boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    efiSupport = false;
  };
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModprobeConfig = ''
    option iwlwifi power_save=0 disable_11ac=1 disable_11ax=1 disable_11be=1
    option iwldvm force_cam=1
  '';

  fileSystems = {
    "/" =
      {
        device = "/dev/disk/by-label/NIXOS";
        fsType = "ext4";
      };
  };
  swapDevices =
    [{ device = "/dev/disk/by-label/SWAP"; }];

  i18n.defaultLocale = lib.mkForce "ru_RU.UTF-8";
  networking.hostName = "gintaras"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.networkmanager.wifi.powersave = false;
  networking.wireless.iwd.enable = true;
  networking.wireless.networks = {
    "free" = { };
  };


  # Set your time zone.
  time.timeZone = "Europe/Vilnius";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wirelesstools
    iw
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.job.logToJournal = true;
  services.xserver.videoDrivers = [ "intel" "amdgpu" "radeon" "nouveau" "modesetting" "fbdev" ];
  services.xserver.desktopManager.xfce = {
    enable = true;
  };

  users.extraUsers.kris.extraGroups = [ "audio" "docker" "video" "render" "wheel" "pulse" ];
  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "23.05";
}
