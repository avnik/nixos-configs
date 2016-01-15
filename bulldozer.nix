# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix = {
    useChroot = true;
    readOnlyStore = true;
    buildCores = 4;    # -j4 for subsequent make calls
    maxJobs = 2;       # Parallel nix builds
    binaryCaches = [
      "http://cache.nixos.org/"
      "http://hydra.nixos.org/"
      "http://hydra.cryp.to/"
    ];
    trustedBinaryCaches = [
      "http://hydra.cryp.to/"
    ];
    extraOptions = ''
        gc-keep-outputs = true
        gc-keep-derivations = true
        auto-optimise-store = true
        binary-caches-parallel-connections = 10
    '';
  };
  nixpkgs.config = {
     allowUnfree = true;
     pulseaudio = true;
     firefox = {
        enableAdobeFlash = true;
     };
     packageOverrides = pkgs: rec {
#        # Avoid failure on rebuild
#        # https://gist.github.com/avnik/647bc1cb68f3c0f16f9e
#    	gcc49 = pkgs.wrapCC (pkgs.lib.overrideDerivation pkgs.gcc49.cc (oldAttrs:  {
#	    	enableParallelBuilding = false;
#	    } // oldAttrs));

        # Attempt to remove ceph (if I can't avoid samba)
        samba = pkgs.samba_light;
        smbclient = pkgs.samba_light;
     };
  };

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 10;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.loader.grub.device = "/dev/disk/by-label/NIXOS";
  boot.loader.grub.version = 2;
  boot.loader.grub.enable = false;
  boot.kernelParams = ["reboot=w,a" "radeon.dpm=1" "radeon.audio=1"  "cgroup_enable=memory" "swapaccount=1"];
  #boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelPackages = pkgs.linuxPackages_4_0;
  boot.kernelModules = [ "r8169" ];
  boot.blacklistedKernelModules = [ "snd_pcsp" ];
  boot.initrd.availableKernelModules = ["btrfs"];
  services.klogd.enable = false;

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

  hardware.enableKSM = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.systemWide = true;
#  hardware.pulseaudio.configFile = "/home/avn/.pulse/default.pa";

  hardware.cpu.amd.updateMicrocode = true;
 
  # networking.wireless.enable = true;  # Enables wireless.

  # Select internationalisation properties.
  i18n = {
     consoleFont = "lat9w-16";
     consoleKeyMap = "us";
     defaultLocale = "en_US.UTF-8";
     supportedLocales = ["en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" "ru_RU.KOI8-R"];
  };

  fileSystems = {
    "/efi"={
       device="/dev/sda1";
       fsType="vfat";
    };
    "/home"={
        device="/dev/vg0/home";
	fsType="ext4";
    };
    "/mnt/data"={
        device="/dev/vg0/data";
	fsType="btrfs";
    };
    "/mnt/raid"={
        device="/dev/vg0/raid";
	fsType="xfs";
    };
    "/mnt/games"={
        device="/dev/vg0/games";
	fsType="xfs";
    };
    "/mnt/systems"={
        device="/dev/vg0/systems";
        fsType="btrfs";
    };
    "/mnt/fast"={
        device="/dev/vg0/video";
        fsType="xfs";
    };
    "/mnt/video"={
    	device="/mnt/fast/video";
	    fsType="none";
    	options="bind";
    };
    "/mnt/debian"={
        device="/dev/vg0/root";
	    fsType="ext4";
    };
    "/etc/nixos/nixpkgs"={
    	device="/home/avn/nixos/nixpkgs";
	    fsType="none";
    	options="bind";
    };
  };

fonts = {
    enableFontDir = true;
#    enableGhostscriptFont = true;
    fonts = with pkgs; [
      	dejavu_fonts
        liberation_ttf
        terminus_font
         xorg.fontcronyxcyrillic
         xorg.fontmisccyrillic
         xorg.fontalias
         ubuntu_font_family
         inconsolata
         corefonts
      ];
};
#services.xfs.enable = true;
services.virtualboxHost.enable = true;
#services.thermald.enable = true;

  services.ntp = {
    enable = true;
    servers = [ "server.local" "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" ];
  };

  # List services that you want to enable:
  services.nfs.server = {
     enable = true;
     exports = ''
/mnt/raid   boomer(rw,no_subtree_check)
/mnt/video   boomer(rw,no_subtree_check)
'';
  };
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.videoDrivers = [ "ati" ];
  services.xserver.exportConfiguration = true;

  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

  environment = {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
    systemPackages = with pkgs; [
      psmisc
      wget
      elinks
      pandoc gnumake zathura
      file lsof zip unzip
      vim
      zsh
      fvwm 
      grub2
      mpv mpg123
      screen
      rtorrent
      rxvt_unicode
      aumix
      qastools
      irssi
      gitFull mercurial nix-prefetch-scripts
      gitAndTools.git-imerge gitAndTools.gitflow gitAndTools.git-remote-hg
      gitAndTools.gitRemoteGcrypt gitAndTools.hub
      nox
      vagrant ansible
      chromium
      pkgs.firefoxWrapper
      xlibs.xkbcomp
      lm_sensors
      pavucontrol
      imagemagick
      emacs
      vcsh mr fasd
      xorg.xdpyinfo xorg.xdriinfo glxinfo xorg.xev xorg.xgamma autocutsel
      manpages pthreadmanpages posix_man_pages stdmanpages iana_etc
      perl pythonFull ruby bundix
      haskellngPackages.xmonad haskellngPackages.xmonad-contrib haskellngPackages.xmonad-extras
      mumble
  ];

  sessionVariables =
      { NIX_PATH =
          [ 
            "nixpkgs=/home/avn/nixos/nixpkgs"
            "nixos=/home/avn/nixos/nixpkgs/nixos"
            "nixos-config=/etc/nixos/configuration.nix"
          ];
      };


    etc = {
	  "hosts".source = ./verbatim/hosts;
    };
  };
  users.extraUsers.avn = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = ["audio" "pulse" "video" "wheel"];
    shell = "/run/current-system/sw/bin/zsh";
  };
  users.extraUsers.olga = {
   isNormalUser = true;
   uid = 1001;
  };
  security = {
    sudo = {
      extraConfig = ''
Defaults:root,%wheel env_keep+=NIX_PATH
      '';
    };
  };
  systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp";
}
