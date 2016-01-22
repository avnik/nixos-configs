{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
      screen tmux elinks
      pythonFull
      rsync
      file lsof zip unzip wget
      gitFull
      vim
    ];
}
