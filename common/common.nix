{ config, pkgs, lib, ... }:
{
  imports = [
     ./nix.nix
     ./nixpkgs.nix
     ./i18n.nix
     ./home-manager.nix
  ];
  boot.blacklistedKernelModules = [ "snd_pcsp" ];
  boot.tmp.useTmpfs = true;
  boot.kernelParams = [ "mitigations=off" "boot.shell_on_fail"];
  boot.loader.grub.memtest86.enable = true;

  hardware = {
    ksm.enable = true;
    enableRedistributableFirmware = lib.mkDefault true;
  };

  documentation = {
    doc.enable = false;
    man.generateCaches = true;
  };

  # Select internationalisation properties.
  console = {
     font = "lat9w-16";
     keyMap = "us";
  };
  i18n = {
     defaultLocale = "en_US.UTF-8";
#     supportedLocales = ["en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" "ru_RU.KOI8-R/KOI8-R" "ru_RU.CP1251/CP1251"];
     supportedLocales = ["all"];
  };

  services.timesyncd.enable = true;

  services.journald = {
    extraConfig = ''
      MaxRetentionSec=1month
    '';
  };

  programs.ssh = {
    startAgent = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  security = {
    sudo = {
      extraConfig = ''
Defaults:root,%wheel env_keep+=NIX_PATH
      '';
    };
  };
}
