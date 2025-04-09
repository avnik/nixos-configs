{ pkgs, lib, config, ... }:
let
  gnupghome = "${config.xdg.dataHome}/gnupg";
in
{
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.wayprompt;
    #pinentryPackage = pkgs.pinentry-qt;
    defaultCacheTtl = 10800;
    defaultCacheTtlSsh = 10800;
  };
  systemd.user.services.gpg-agent = {
    Service = {
      Environment = lib.mkForce [
        "GPG_TTY=/dev/tty1"
        "DISPLAY=:0"
        "GNUPGHOME=${gnupghome}"
      ];
    };
  };
  home.sessionVariables = { GNUPGHOME = gnupghome; };
  programs.zsh.sessionVariables = { GNUPGHOME = gnupghome; };

  programs.gpg = {
    enable = true;
    homedir = gnupghome;
  };
  home.packages = with pkgs; [ wayprompt pinentry-qt ];
}
