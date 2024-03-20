# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../common/common.nix
      ../../users.nix
      ../../roles/console.nix
      ../../roles/desktop.nix
      ../froggy/pulse.nix
      ../../roles/gaming.nix
      ../../roles/steam.nix
      ../../roles/printing.nix
      ../../roles/X11.nix
      ../../envs/wine.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };
    };
    #kernelPackages = pkgs.linuxPackages;
    kernelPackages = pkgs.linuxPackages_latest;
  };
  hardware.cpu.amd.updateMicrocode = true;
  hardware.bluetooth.enable = true;

  fileSystems = {
    "/mnt/media" = {
      device = "bulldozer:/mnt/media";
      fsType = "nfs";
    };
    "/mnt/video" = {
      device = "bulldozer:/mnt/video";
      fsType = "nfs";
    };
    "/mnt/raid" = {
      device = "bulldozer:/mnt/raid";
      fsType = "nfs";
    };
  };


  # Set your time zone.
  time.timeZone = "Europe/Vilnius";

  networking.hostName = "starflyer"; # Define your hostname.
  networking.domain = "home";
  networking.search = [ "home" ];
  networking.hostId = "2f78bb0e";
  networking.interfaces.enp9s0.ipv4.addresses = [{ address = "172.16.228.4"; prefixLength = 24; }];
  networking.defaultGateway = "172.16.228.1";
  networking.nameservers = [ "172.16.228.1" ];
  networking.firewall.enable = false;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    ethtool
    lm_sensors
    claws-mail
    obs-studio
    tdesktop # Not include full chat role, due size constraints
  ];

  # List services that you want to enable:
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleSuspendKey=ignore
  '';

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.PermitRootLogin = "yes";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "intel" "amdgpu" "radeon" "nouveau" "modesetting" "fbdev" ];
  services.xserver.desktopManager.xfce = {
    enable = true;
  };
  services.xserver.displayManager.defaultSession = "xfce";
  services.xserver.displayManager.job.logToFile = true;

  users.extraUsers.olga.extraGroups = [ "audio" "docker" "video" "render" "wheel" "pulse" ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "21.09";
}
