# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      inputs.private.nixosModules.initial-passwords
      inputs.disko.nixosModules.disko
      ./disko.nix

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../common/common.nix
      ../../common/pipewire.nix
      ../../users.nix
      ../../roles/console.nix
      ../../roles/desktop.nix
      ../../roles/gaming.nix
      ../../roles/chats.nix
      ../../roles/steam.nix
      ../../roles/printing.nix
      ../../roles/X11.nix
      ../../roles/earlyoom.nix
      ../../envs/wine.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    #kernelPackages = pkgs.linuxPackages;
    kernelPackages = pkgs.linuxPackages_latest;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
  hardware.cpu.amd.updateMicrocode = true;
  hardware.bluetooth.enable = true;

  fileSystems = {
    "/mnt/media" = {
      device = "bulldozer:/mnt/media";
      fsType = "nfs";
      options = [ "nofail" "x-systemd.automount" "x-systemd.requires=network-online.target" "x-systemd.device-timeout=10s"];
    };
    "/mnt/raid" = {
      device = "bulldozer:/mnt/raid";
      fsType = "nfs";
      options = [ "nofail" "x-systemd.automount" "x-systemd.requires=network-online.target" "x-systemd.device-timeout=10s"];
    };
  };


  # Set your time zone.
  time.timeZone = "Europe/Vilnius";

  networking.hostName = "viper"; # Define your hostname.
  networking.domain = "home";
  networking.search = [ "home" ];
  networking.hostId = "2f78bb0f";
  networking.networkmanager.enable = true;
  networking.wireless.networks = {
    "free" = { };
  };
  networking.firewall.enable = false;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    ethtool
    lm_sensors
    gnome-bluetooth
    #claws-mail
    # obs-studio
  ];

  powerManagement.cpuFreqGovernor = "powersave"; # FIXME: changed form "ondemand"

  # List services that you want to enable:
  services.dbus.implementation = "broker";
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleSuspendKey=ignore
  '';

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.PermitRootLogin = "yes";

  services.udev.extraRules = ''
    # ACTION=="add", SUBSYSTEM=="net", DEVTYPE!="?*", ATTR{address}=="1c:bf:ce:bd:f1:dd", NAME="usbeth0"
    ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="1c:bf:ce:bd:f1:dd", NAME="usbeth0"
  '';

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" "radeon" "modesetting" "fbdev" ];
  services.xserver.desktopManager.xfce = {
    enable = true;
  };
  services.displayManager.defaultSession = "xfce";
  services.displayManager.logToFile = true;

  users.extraUsers.olga.extraGroups = [ "audio" "docker" "video" "render" "wheel" "pulse" ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "21.09";
}
