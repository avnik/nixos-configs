# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./users.nix
      ./common/common.nix
      ./common/efi.nix
      ./roles/console.nix
      ./roles/desktop.nix
      ./roles/X11.nix
      ./roles/emacs.nix
    ];

  boot.initrd.luks = {
    cryptoModules = [ "aes_x86_64" "xts" "ecb" "cbc" "sha256_generic" "sha512_generic"];
    devices = [ {
      name="cryptolvm";
      device = "/dev/sda3";
      preLVM = true;
    } ];
  };

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

  nix.binaryCaches = [ "http://bulldozer.home" ];
  networking.hostName = "boomer"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Vilnius";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    libreoffice
    deadbeef-with-plugins
    abcde
    xfce.thunar
   ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";
   services.xserver.synaptics.enable = false;
   services.xserver.displayManager.job.logsXsession = true;
   services.xserver.windowManager.qtile.enable = true; 

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";
  users.extraUsers.olga.extraGroups= ["audio" "docker" "video" "wheel" "pulse"];
}
