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
      ../../roles/taskwarrior.nix
      ../../roles/steam.nix
      ../../roles/haskell.nix
      ../../roles/texlive.nix
      ../../class/customers/central.nix
      ../../users.nix
      ../../envs/golang.nix
      ../../envs/rust.nix
      ../../envs/wine.nix
      ./boot.nix
      ./fs.nix
      ./mail.nix
      ./taskd.nix
      ./openvpn.nix
    ];

  nixpkgs.config = {
     allowBroken = true;  # Until ansible will be fixed
  };

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
    172.16.228.9 boomer
  '';

  hardware = {
      opengl = {
          driSupport32Bit = true;
          s3tcSupport = true;
      };
      enableKSM = true;
      pulseaudio = {
          enable = true;
          systemWide = true;
          daemon.config = {
            default-fragments = 10;
            default-fragment-size-msec = 2;
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

  nix-serve = {
    enable = true;
    secretKeyFile = "/etc/nixos/secrets/nix-bulldozer.key";
  };

  smartd.enable = true;

  nfs.server = {
     enable = true;
     exports = ''
/mnt/raid   boomer(rw,no_subtree_check)
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
      pandoc gnumake
      neovim
      svtplay-dl
      rtorrent
      mercurial nix-prefetch-scripts
      gitAndTools.git-imerge gitAndTools.gitflow gitAndTools.git-remote-hg
      gitAndTools.gitRemoteGcrypt gitAndTools.hub gist gitAndTools.topGit
      nox
      vagrant ansible
      lm_sensors smartmontools hdparm fio
      imagemagick
      vcsh mr fasd rcm renameutils
      manpages posix_man_pages iana_etc
      perl pythonFull ruby bundix
      #mumble_git teamspeak_client pidgin-with-plugins
      pass
      rkt
      gnome3.vinagre
      docker-gc docker-compose
      binutils-stuff
      remmina rdesktop
      hledger
      nix-review
      perf-tools
      awscli
      circleci-cli
  ];
  sessionVariables =
      { 
      };


    etc = {
#	  "hosts".source = ../../verbatim/hosts;
    };
  };

  system.stateVersion = "19.03";
}
