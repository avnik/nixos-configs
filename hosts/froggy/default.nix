# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../common/common.nix
      ../../users.nix
      ./network.nix
      ./mail.nix
      ./openvpn.nix
      ../../roles/console.nix
      ../../roles/desktop.nix
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
        version = 2;
        enable = true;
        device = "nodev";
        efiSupport = true;
      };
    };
    extraModprobeConfig = ''
      options iwlwifi swcrypto=1 11n_disable=1
      options iwlmvm power_scheme=1
    '';
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [ "intel_idle.max_cstate=1" "processor.max_cstate=1" "idle=poll" "pcie_aspm=off" ];
  };
  hardware.cpu.intel.updateMicrocode = true;

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
    xfce.thunar
#    geeqie
    tcpdump
    vim
    krita
    ethtool
    lm_sensors
    multimc
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "no";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services.xserver.videoDrivers = [ "intel" ];



  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.09";

}
