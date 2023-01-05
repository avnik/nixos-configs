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
      ../../roles/chats.nix
      ../../roles/desktop.nix
      ../../roles/X11.nix
      ../../roles/gaming.nix
      ../../roles/printing.nix
    ];

  boot.initrd.luks = {
    cryptoModules = [ "aes_generic" "xts" "ecb" "cbc" "sha256_generic" "sha512_generic"];
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
  hardware = {
      bluetooth = {
        enable = true;
        settings = {
          General = {
            Enable = "Source,Sink,Media,Socket";
          };
        };
      };
      opengl = {
          driSupport32Bit = true;
      };
      pulseaudio = {
          enable = true;
          configFile = ./verbatim/system.pa;
          systemWide = true;
          daemon.config = {
            default-fragments = 10;
            default-fragment-size-msec = 2;
          };
          extraModules = [ ];
          package = pkgs.pulseaudioFull;
      };
      cpu.amd.updateMicrocode = true;
  };
  powerManagement.cpuFreqGovernor = "powersave";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    abcde
    xfce.thunar
    geeqie
    evince
   ];

  # List services that you want to enable:
  services.blueman.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;


  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";
   services.xserver.synaptics.enable = false;
   services.xserver.displayManager.job.logToFile = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";
  users.extraUsers.olga.extraGroups= ["audio" "docker" "video" "render" "wheel" "pulse"];
}
