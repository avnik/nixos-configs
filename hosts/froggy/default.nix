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
      ./network.nix
      ./mail.nix
      ./openvpn.nix
      ../../roles/console.nix
      ../../roles/desktop.nix
      ./../../common/pipewire.nix
      #      ../../roles/camera.nix
      ../../roles/chats.nix
      #      ../../roles/gaming.nix
      #      ../../roles/steam.nix
      ../../roles/printing.nix
      ../../roles/X11.nix
      #      ../../envs/wine.nix
      ../../modules/r8168.nix
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
    extraModprobeConfig = ''
      #options iwlwifi swcrypto=1 11n_disable=1
      #options iwlmvm power_scheme=1
      blacklist iwlwifi
      blacklist iwlmvm
    '';
    kernelPackages = pkgs.linuxPackages;
    #kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "intel_idle.max_cstate=1" "processor.max_cstate=1" "idle=poll" "pcie_aspm=off" ];
  };
  services.udev.extraRules = ''
    # SUBSYSTEM=="net", ACTION=="add", DEVTYPE=="wlan", ATTR{address}=="00:C0:CA:81:F3:AD", NAME="wifi1"
    SUBSYSTEM=="net", ACTION=="add", ATTRS{manufacturer}=="ATHEROS", NAME="wifi1"
  '';
  hardware.cpu.intel.updateMicrocode = true;
  hardware.custom.r8168.enable = false;

  fileSystems = {
    "/mnt/media" = {
      device = "bulldozer:/mnt/media";
      fsType = "nfs";
    };
    "/mnt/video" = {
      device = "bulldozer:/mnt/video";
      fsType = "nfs";
    };
  };


  # Set your time zone.
  time.timeZone = "Europe/Vilnius";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    tcpdump
    vim
    ethtool
    lm_sensors
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.PermitRootLogin = "yes";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.desktopManager.xfce = {
    enable = true;
  };
  services.xserver.displayManager.defaultSession = "xfce";
  services.system-config-printer.enable = false;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.09";
}
