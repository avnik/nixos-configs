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
      pandoc
      screen tmux elinks
      pythonFull
      rsync
      psmisc  # for killall
      sysstat # for iostat
      tcpdump
      iotop htop
      bup     # for backup tool
      shared_mime_info
      file lsof zip unzip unrar wget p7zip xorriso
      libxslt.bin # for xsltproc
      gitAndTools.gitFull git-crecord git-series
      whois       # for whois
      fd          # for super-fast `find`
      telnet      # for telnet
      nix-index
      nix-du
    ];
}
