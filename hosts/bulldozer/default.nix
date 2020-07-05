# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

with lib;

{
  imports =
    [ 
      ../../common/common.nix
      ../../roles/camera.nix
      ../../roles/chats.nix
      ../../roles/emacs.nix
      ../../roles/X11.nix
      ../../roles/desktop.nix
      ../../roles/console.nix
      ../../roles/gaming.nix
      ../../roles/steam.nix
      ../../roles/haskell.nix
      ../../roles/texlive.nix
      ../../roles/nixpkgs-maintainer.nix
      ../../roles/dev/ftdi.nix
      ../../users.nix
      ../../envs/golang.nix
      ../../envs/rust.nix
      ../../envs/wine.nix
      ./boot.nix
      ./fs.nix
      ./mail.nix
      ./taskd.nix
      ./openvpn.nix
#      ../../modules/extras.nix
    ];

  nixpkgs.config = {
     allowBroken = true;  # Until ansible will be fixed
  };
#  extras.iohkOverlays = true;

  powerManagement.cpuFreqGovernor = "ondemand";
  time.timeZone = "Europe/Vilnius";

  networking.hostName = "bulldozer"; # Define your hostname.
  networking.domain = "home";
  networking.search = ["home"];
  networking.hostId = "2f78bb0d";
  networking.interfaces.enp9s0.ipv4.addresses = [ { address = "172.16.228.3"; prefixLength = 24;} ];
  networking.defaultGateway = "172.16.228.1";
  networking.nameservers  = [ "172.16.228.1" ];
  networking.firewall.enable = false;
  networking.extraHosts = ''
    199.199.199.204 twt.tais.com twp.tais.com
    172.16.228.1 froggy
    172.16.228.10 printer printer.home
    172.16.228.7 raptor 
    172.16.228.9 boomer
  '';

  hardware = {
      opengl = {
          driSupport32Bit = true;
      };
      pulseaudio = {
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
      cpu.amd.updateMicrocode = true;
  };

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
#    rkt.enable = true;
};

services = {
#  syslog-ng.enable = true;
  klogd.enable = false;
  logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleSuspendKey=ignore
  '';

  nix-serve = {
    enable = true;
    secretKeyFile = "/etc/nixos/secrets/nix-bulldozer.key";
  };

  avahi.enable = true;
  nginx = {
    enable = true;
    virtualHosts."bulldozer.home" = {
      enableACME = false;
      forceSSL = false;
      root = "/home/www";
    };
  };


  smartd.enable = true;

  nfs.server = {
     enable = true;
     exports = ''
/mnt/raid   boomer(rw,no_subtree_check) raptor(rw,no_subtree_check)
/mnt/video   boomer(rw,no_subtree_check) froggy(ro,no_subtree_check)
/mnt/media   boomer(rw,no_subtree_check) froggy(ro,no_subtree_check)
       '';
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  environment = {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
    systemPackages = with pkgs; [
      gnumake
      neovim
      rtorrent
      mercurial
      pre-commit gist
      nox
      vagrant ansible
      lm_sensors smartmontools hdparm
      imagemagick
      vcsh mr fasd rcm renameutils jump
      manpages posix_man_pages iana_etc
      perl pythonFull ruby bundix
      pass gopass gnupg
      gnome3.vinagre
      docker-compose
      binutils-stuff
      remmina rdesktop
      hledger
      nix-review
      nixpkgs-fmt
      perf-tools
      awscli
      usbutils
      conky
      jq
      direnv
      picocom
      cutecom
      sshpass
      dateutils
      x11docker
  ] ++ (with pkgs.gitAndTools; [
      gitflow git-remote-hg git-sizer
      gitRemoteGcrypt hub topGit delta 
      git-absorb git-gone git-machete git-octopus git-recent
      git-quick-stats
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
