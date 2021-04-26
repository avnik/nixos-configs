# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.
      ../../users.nix
      ../../common/common.nix
      ../../common/efi.nix
      ../../roles/console.nix
      ../../roles/desktop.nix
      ../../roles/X11.nix
      ../../roles/emacs.nix
      ../../roles/gaming.nix
      ../../roles/printing.nix
    ];

  boot.initrd.luks = {
    cryptoModules = [ "aes_x86_64" "xts" "ecb" "cbc" "sha256_generic" "sha512_generic"];
    devices = { 
      cryptolvm = {
        name="cryptolvm";
        device = "/dev/sda3";
        preLVM = true;
      };
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems = {
      "/mnt/raid" = {
          device = "bulldozer:/mnt/raid";
          fsType = "nfs";
      };
      "/mnt/video" = {
          device = "bulldozer:/mnt/video";
          fsType = "nfs";
      };
  };

  networking.hostName = "boomer"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.wireless.networks = {
    "free" = {};
  };

  # Set your time zone.
  time.timeZone = "Europe/Vilnius";

  hardware.pulseaudio.configFile = ./verbatim/system.pa;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    libreoffice
    abcde
    xfce.thunar
    geeqie
    evince
   ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;


  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";
   services.xserver.synaptics.enable = false;
   services.xserver.displayManager.job.logsXsession = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";
  users.extraUsers.olga.extraGroups= ["audio" "docker" "video" "render" "wheel" "pulse"];
}
