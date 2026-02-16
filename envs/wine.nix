{
  lib,
  config,
  pkgs,
  ...
}:

let
  extraCmds = ''
    export LIBGL_DEBUG=verbose
    export MESA_DEBUG=1
    export __GL_SYNC_TO_VBLANK=1
  '';
  stdenv = pkgs.stdenv;
  glxinfo32 = pkgs.pkgsi686Linux.mesa-demos;
  wineWowStaging = pkgs.wineWow64Packages.full.override {
    wineRelease = "staging";
    #    gstreamerSupport = false;
  };
  wineWowStable = pkgs.wineWow64Packages.full.override {
    #    wineRelease = "stable";
    #    gstreamerSupport = false;
  };
  wineEnv = pkgs.myEnvFun {
    name = "wine-gaming";
    buildInputs = with pkgs; [
      wineWowStaging
      winetricks
      mesa
      mesa-demos
      cabextract
    ];
    inherit extraCmds;
  };
  wineEnvStable = pkgs.myEnvFun {
    name = "wine-stable";
    buildInputs = with pkgs; [
      wineWowStable
      winetricks
      mesa
      mesa-demos
      cabextract
    ];
    inherit extraCmds;
  };
in
{
  environment.systemPackages = [
    wineEnv
    wineEnvStable
  ];
}
