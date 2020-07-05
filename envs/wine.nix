{ config, pkgs, ... }:

let
  extraCmds = ''
      export LIBGL_DEBUG=verbose
      export MESA_DEBUG=1
      export __GL_SYNC_TO_VBLANK=1
  '';
  stdenv = pkgs.stdenv;
  mesa32 = pkgs.pkgsi686Linux.mesa_noglu;
  glxinfo32 = pkgs.pkgsi686Linux.glxinfo;
  wine32 = pkgs.stdenv.lib.overrideDerivation pkgs.pkgsi686Linux.wineStaging (oldAttrs : {
      patch = [
      ];
  });
  winetricks32 = pkgs.winetricks.override { wine = wine32; };
  wine32Env = pkgs.myEnvFun {
    name = "wine-gaming-32";
    buildInputs = [ wine32 winetricks32 mesa32 glxinfo32 ];
    inherit extraCmds;
  };
  wineWowStaging = pkgs.wineWowPackages.full.override {
    wineRelease = "staging";
    gstreamerSupport = false;
  };
  wineWowStable = pkgs.wineWowPackages.full.override {
    wineRelease = "stable";
    gstreamerSupport = false;
  };
  winetricksStaging = pkgs.winetricks.override { wine = wineWowStaging; };
  winetricksStable = pkgs.winetricks.override { wine = wineWowStable; };
  wineEnv = pkgs.myEnvFun {
    name = "wine-gaming";
    buildInputs = with pkgs; [ wineWowStaging winetricksStaging mesa glxinfo cabextract ];
    inherit extraCmds;
  };
  wineEnvStable = pkgs.myEnvFun {
    name = "wine-stable";
    buildInputs = with pkgs; [ wineWowStable winetricksStable mesa glxinfo cabextract ];
    inherit extraCmds;
  };
in
{
        environment.systemPackages = [ wineEnv ];
}
