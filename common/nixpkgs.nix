{ config, pkgs, ... }:
{
  nixpkgs.config = {
     allowUnfree = true;
     pulseaudio = true;
     mpv = {
         cacaSupport = false;
         SDL2Support = true; # FIXME: require fix in nixpkgs/toplevel/all-packages
     };
     packageOverrides = pkgs: rec {
#        # Avoid failure on rebuild
#        # https://gist.github.com/avnik/647bc1cb68f3c0f16f9e
#       gcc49 = pkgs.wrapCC (pkgs.lib.overrideDerivation pkgs.gcc49.cc (oldAttrs:  {
#           enableParallelBuilding = false;
#       } // oldAttrs));

        # Attempt to remove ceph (if I can't avoid samba)
        samba = pkgs.samba_light;
        smbclient = pkgs.samba_light;
        texLive = pkgs.texLive.override {
            preferLocalBuild = true;
        };
        pidgin-with-plugins =  pkgs.pidgin-with-plugins.override {
            plugins = [ pkgs.purple-plugin-pack pkgs.toxprpl pkgs.pidginotr pkgs.skype4pidgin pkgs.pidginwindowmerge ];
        };
     };
  };
}
