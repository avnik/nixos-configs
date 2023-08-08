# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

with lib;
/*
let 
  mesa_version = "21.1.3";
  mesa_src = pkgs.fetchurl {
    url = "https://mesa.freedesktop.org/archive/mesa-${mesa_version}.tar.xz";
    sha256 = "0s8yi7y63xsyqw19ihil18fykkjxr6ibcir2fvymz1vh4ql23qnb";
  };  
  mesa_21_1 = pkgs.mesa.overrideAttrs (a: { src = mesa_src; version = mesa_version; patches = sublist 1 2 a.patches; });
  mesa_21_1_32 = pkgs.pkgsi686Linux.mesa.overrideAttrs (a: { src = mesa_src; version = mesa_version; patches = sublist 1 2 a.patches; });
in
*/
{
  imports =
    [ 
      ../../common/common.nix
      ../../common/pipewire.nix
      ../../roles/camera.nix
      ../../roles/chats.nix
      ../../roles/X11.nix
      ../../roles/desktop.nix
      ../../roles/console.nix
      ../../roles/gaming.nix
      ../../roles/steam.nix
#      ../../roles/texlive.nix
      ../../roles/nixpkgs-maintainer.nix
      ../../roles/wayland.nix
      ../../roles/greetd.nix
      ../../roles/printing.nix
      ../../users.nix
      ../../envs/wine.nix
      ./boot.nix
      ./fs.nix
      ./mail.nix
      ./openvpn.nix
      ./samba.nix
      ./portal.nix
      ./set-profile.nix
    ];

  nix.buildMachines = [{
     hostName = "awsarm";
     system = "aarch64-linux";
     protocol = "ssh-ng";
     maxJobs = 1;
     speedFactor = 2;
     supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
     mandatoryFeatures = [ ];
     sshUser = "avnik";
   }];

   nix.distributedBuilds = true;
   # optional, useful when the builder has a faster internet connection than yours
   nix.extraOptions = ''
     builders-use-substitutes = true
   '';

  nixpkgs.config = {
     allowBroken = true;  # Until ansible will be fixed
  };

  powerManagement.cpuFreqGovernor = "ondemand";
  time.timeZone = "Europe/Vilnius";

  networking.hostName = "bulldozer"; # Define your hostname.
  networking.domain = "home";
  networking.search = ["home"];
  networking.hostId = "2f78bb0d";
  networking.interfaces.enp6s0.ipv4.addresses = [ { address = "172.16.228.3"; prefixLength = 24;} ];
  networking.defaultGateway = "172.16.228.1";
  networking.nameservers  = [ "172.16.228.1" ];
  networking.firewall.enable = false;
  networking.extraHosts = ''
    199.199.199.204 twt.tais.com twp.tais.com
    172.16.228.1 froggy
    172.16.228.10 printer printer.home
    172.16.228.7 raptor 
    172.16.228.9 boomer
    172.16.228.4 starflyer
  '';

  hardware = {
      bluetooth.enable = true;
      opengl = {
          driSupport32Bit = true;
#          package = mkForce mesa_21_1.drivers;
#          package32 = mkForce mesa_21_1_32.drivers;
      };
/*      pulseaudio = {
          enable = true;
          systemWide = true;
          configFile = ./verbatim/system.pa;
          daemon.config = {
            default-fragments = 10;
            default-fragment-size-msec = 2;
            default-sample-format = "s16le";
            default-sample-rate = 48000;
          };
      };
  */
      #cpu.amd.updateMicrocode = true;
      cpu.intel.updateMicrocode = true;
  };
  #systemd.services.pulseaudio.restartIfChanged = false;

# List services that you want to enable:
virtualisation = {
    virtualbox.host.enable = false;
    docker = {
        enable = true;
        storageDriver = "zfs";
        autoPrune = {
          enable = true;
          dates = "daily";
        };
    };
};

programs.sway.enable = true;
set-profile.enable = true;
services = {
#  syslog-ng.enable = true;
  logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleSuspendKey=ignore
  '';

#  nix-serve = {
#    enable = true;
#    secretKeyFile = "/etc/nixos/secrets/nix-bulldozer.key";
#  };

  avahi.enable = true;
  nginx = {
    enable = true;
    logError = "/var/log/nginx/error.log info";
    virtualHosts."bulldozer.home" = {
      enableACME = false;
      forceSSL = false;
      root = "/var/www";
    };
  };


  smartd.enable = true;

  nfs.server = {
     enable = true;
     exports = ''
/mnt/raid   boomer(rw,no_subtree_check) raptor(rw,no_subtree_check) starflyer(rw,no_subtree_check)
/mnt/video   boomer(rw,no_subtree_check) froggy(ro,no_subtree_check) starflyer(rw,no_subtree_check)
/mnt/media   boomer(rw,no_subtree_check) froggy(ro,no_subtree_check) starflyer(rw,no_subtree_check) 
       '';
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;

#  services.xserver.deviceSection = ''
#    Option "DRI3" "on"
#  '';
#  services.xserver.videoDrivers = [ "amdgpu" "radeon" ];

  environment = {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
    systemPackages = with pkgs; [
      neovim
      rtorrent
      mercurial
      pre-commit gist
      imagemagick
      fasd renameutils jump
      man-pages man-pages-posix
      python3Full
      gopass
      docker-compose
      binutils-stuff
      remmina rdesktop
      hledger
      perf-tools
      awscli
      sshpass
      edac-utils dmidecode efibootmgr lshw
      xsane
      ffmpeg
      gnome.gnome-bluetooth
  ] ++ (with pkgs.gitAndTools; [
      gitflow
      git-remote-gcrypt hub delta 
      git-absorb git-gone git-machete git-octopus git-recent
      git-quick-stats git-delete-merged-branches
      gh
  ]);
  sessionVariables =
      { 
      };


    etc = {
#	  "hosts".source = ../../verbatim/hosts;
    };
  };

  system.stateVersion = "19.03";
}
