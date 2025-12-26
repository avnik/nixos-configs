# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs, lib, ... }:

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
      # Private part of config, which I won't expose
      inputs.private.nixosModules.bulldozer

      # Theming
      ../../common/style.nix

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
      ./wireguard.nix

      ../../secrets/bulldozer/secrets.nix
    ];

  /*
    nix.buildMachines = [{
    # Moved to private part of config
    }];
  */

  nix = {
    distributedBuilds = true;
    buildMachines = [{
      hostName = "starflyer";
      system = "aarch64-linux"; # emulated!
      protocol = "ssh-ng";
      maxJobs = 1;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "kvm" ]; # No "big-parallel"
      mandatoryFeatures = [ ];
      sshUser = "root";
    }];
    # optional, useful when the builder has a faster internet connection than yours
    extraOptions = ''
      builders-use-substitutes = true
    '';
    settings = {
      cores = lib.mkForce 16; # -j4 for subsequent make calls
      max-jobs = lib.mkForce 3; # Parallel nix builds
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";
  time.timeZone = "Europe/Vilnius";

  networking.hostName = "bulldozer"; # Define your hostname.
  networking.domain = "home";
  networking.search = [ "home" ];
  networking.hostId = "2f78bb0d";
  networking.interfaces.enp6s0.ipv4.addresses = [{ address = "172.16.228.3"; prefixLength = 24; }];
  networking.defaultGateway = "172.16.228.1";
  networking.nameservers = [ "172.16.228.1" ];
  networking.firewall.enable = false;
  networking.extraHosts = ''
    172.16.228.1 froggy
    172.16.228.10 printer printer.home
    172.16.228.7 raptor 
    172.16.228.9 boomer
    172.16.228.4 starflyer
  '';

  hardware = {
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    graphics = {
      enable32Bit = true;
      #          package = mkForce mesa_21_1.drivers;
      #          package32 = mkForce mesa_21_1_32.drivers;
    };
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
    dbus.implementation = "broker";
    logind.settings.Login = {
      HandlePowerKey = "ignore";
      HandleSuspendKey = "ignore";
    };

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
        /mnt/raid   viper(rw,no_subtree_check) raptor(rw,no_subtree_check) starflyer(rw,no_subtree_check)
        /mnt/media   viper(rw,no_subtree_check) froggy(ro,no_subtree_check) starflyer(rw,no_subtree_check) 
      '';
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  #  services.clamav.daemon.enable = true;
  #  services.clamav.updater.enable = true;

  environment = {
    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    systemPackages = with pkgs; [
      neovim
      rtorrent
      tla
      imagemagick
      renameutils
      man-pages
      man-pages-posix
      python3
      gopass
      docker-compose
      binutils-stuff
      remmina
      hledger
      perf-tools
      awscli
      sshpass
      edac-utils
      dmidecode
      efibootmgr
      xsane
      ffmpeg
      gnome-bluetooth
      qemu
      socat
      distrobox
      openconnect
      inputs.agenix.packages.${pkgs.stdenv.system}.agenix
      git-remote-gcrypt
      git-absorb
      git-gone
      git-machete
      git-octopus
      git-recent
      git-quick-stats
      git-delete-merged-branches
      git-stack
      gh
    ];
    sessionVariables =
      { };


    etc = {
      #	  "hosts".source = ../../verbatim/hosts;
    };
  };

  system.stateVersion = "19.03";
}
