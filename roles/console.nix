{ config, pkgs, ... }:
{
    imports = [ ./vim.nix ];

    nixpkgs.overlays = [
        (self: super: {
            gitAndTools = super.gitAndTools // {
                gitFull = super.gitAndTools.gitFull.override { guiSupport = config.services.xserver.enable; };
            };
        })
    ];

    environment.systemPackages = with pkgs; [
      screen tmux elinks
      pythonFull
      rsync
      psmisc # for killall
      sysstat # for iostat
      file lsof zip unzip unrar wget p7zip
      libxslt.bin # for xsltproc
      gitAndTools.gitFull git-crecord git-up
    ];
}
