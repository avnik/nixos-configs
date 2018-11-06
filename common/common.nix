{ config, pkgs, ... }:
{
  imports = [
     ./nix.nix
     ./nixpkgs.nix
     ./i18n.nix
  ];
  boot.blacklistedKernelModules = [ "snd_pcsp" ];
  boot.tmpOnTmpfs = true;

  hardware.enableKSM = true;

  # Select internationalisation properties.
  i18n = {
     consoleFont = "lat9w-16";
     consoleKeyMap = "us";
     defaultLocale = "en_US.UTF-8";
#     supportedLocales = ["en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" "ru_RU.KOI8-R/KOI8-R" "ru_RU.CP1251/CP1251"];
     supportedLocales = ["all"];
  };

  services.ntp = {
    enable = true;
    servers = [ "server.local" "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" ];
  };

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
