{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
      vim
      screen tmux elinks
      pythonFull
      rsync
      file lsof zip unzip unrar wget p7zip
      gettext # needed for git rebase
      libxslt.bin # xsltproc
    ] ++ (if config.services.xserver.enable then [
      gitAndTools.gitFull
    ] else [
      (gitAndTools.gitFull.override { guiSupport = false; })
    ]);
}
