# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

with lib;

{
  imports =
    [ 
      ../../common/common.nix
      ../../roles/emacs.nix
      ../../roles/X11.nix
      ../../roles/desktop.nix
      ../../roles/console.nix
      ../../roles/gaming.nix
      ../../roles/taskwarrior.nix
      ../../users.nix
      ../../envs/golang.nix
      ../../envs/haskell.nix
      ../../envs/ocaml.nix
      ../../envs/wine.nix
      ./boot.nix
      ./fs.nix
      ./mail.nix
      ./taskd.nix
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
  networking.interfaces.enp9s0.ip4 = [ { address = "172.16.228.3"; prefixLength = 24;} ];
  networking.defaultGateway = "172.16.228.1";
  networking.nameservers  = [ "172.16.228.1" ];
  networking.firewall.enable = false;

  hardware = {
      opengl = {
          driSupport32Bit = true;
          s3tcSupport = true;
      };
      enableKSM = true;
      pulseaudio = {
          enable = true;
          systemWide = true;
      };
      cpu.amd.updateMicrocode = true;
  };

# List services that you want to enable:
virtualisation = {
    virtualbox.host.enable = true;
#    docker = {
#        enable = true;
#        storageDriver = "btrfs";
#    };
#    rkt.enable = true;
};

services = {
  syslog-ng.enable = true;
  klogd.enable = false;

  nix-serve = {
    enable = true;
    secretKeyFile = "/etc/nixos/secrets/nix-bulldozer.key";
  };

  nfs.server = {
     enable = true;
     exports = ''
/mnt/raid   boomer(rw,no_subtree_check)
/mnt/video   boomer(rw,no_subtree_check)
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
      irssi
      mercurial nix-prefetch-scripts
      gitAndTools.git-imerge gitAndTools.gitflow gitAndTools.git-remote-hg
      gitAndTools.gitRemoteGcrypt gitAndTools.hub gist gitAndTools.topGit
      nox
      vagrant ansible
      lm_sensors
      imagemagick
      vcsh mr fasd rcm renameutils
      manpages posix_man_pages iana_etc
      perl pythonFull ruby bundix
      mumble_git teamspeak_client pidgin-with-plugins
      pass
      texlive.combined.scheme-full
      # npm2nix
      nix-repl
      rkt acbuild
      gnome3.vinagre
      cabal-install cabal2nix
      docker-gc pythonPackages.docker_compose
#      drone.bin
      own.binutils-stuff
  ];
  sessionVariables =
      { 
      };


    etc = {
	  "hosts".source = ../../verbatim/hosts;
    };
  };
}
