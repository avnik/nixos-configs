{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
      vim
      screen tmux elinks
      pythonFull
      rsync
      psmisc # for killall
      file lsof zip unzip unrar wget p7zip
      libxslt.bin # for xsltproc
    ] ++ (if config.services.xserver.enable then [
      gitAndTools.gitFull
    ] else [
      (gitAndTools.gitFull.override { guiSupport = false; })
    ]);
}
