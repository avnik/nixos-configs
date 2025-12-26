# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ../../users.nix
      ../../common/common.nix
      ../../roles/console.nix
      ../../roles/desktop.nix
      #      ../../roles/X11.nix
      ../../common/fonts.nix
      ../../roles/chats.nix
      ../../roles/greetd.nix
    ];

  # Don't use the gummiboot efi boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    version = 2;
    efiSupport = false;
  };

  boot.initrd.luks = {
    cryptoModules = [ "aes_generic" "xts" "ecb" "cbc" "sha256_generic" "sha512_generic" ];
    devices.cryptolvm = {
      device = "/dev/sda5";
      preLVM = true;
    };
  };

  fileSystems = {
    "/" =
      {
        device = "/dev/disk/by-uuid/dcc3bed8-5aac-4578-a987-6754daf06c39";
        fsType = "xfs";
      };

    "/boot" =
      {
        device = "/dev/disk/by-uuid/3a1a8c73-e595-4097-bd0d-51e4f3aa396c";
        fsType = "ext4";
      };
  };
  swapDevices =
    [{ device = "/dev/disk/by-uuid/625aabf3-7c8f-4918-9331-0a98d20ed4eb"; }];

  networking.hostName = "raptor"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.wireless.networks = {
    "free" = { };
  };


  # Set your time zone.
  time.timeZone = "Europe/Vilnius";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # that host too small for fit full chats and gaming roles
    irssi
    telegram-desktop
    openxcom-extended
    i3
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = false;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";
  services.xserver.synaptics.enable = false;
  services.xserver.displayManager.job.logToJournal = true;

  users.extraUsers.olga.extraGroups = [ "audio" "docker" "video" "render" "wheel" "pulse" ];
  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "20.09";
}
