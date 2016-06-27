{ config, pkgs, ... }:

let
  stdenv = pkgs.stdenv;
  libtxc_dxtn = pkgs.pkgsi686Linux.libtxc_dxtn;
  mesa = pkgs.pkgsi686Linux.mesa_noglu.override { enableTextureFloats = true; };
  glxinfo = pkgs.pkgsi686Linux.glxinfo;
  wine = pkgs.stdenv.lib.overrideDerivation pkgs.pkgsi686Linux.wineStaging (oldAttrs : {
      libtxc_dxtn_Name = pkgs.pkgsi686Linux.libtxc_dxtn;
      patch = [
      ];
  });
  winetricks = pkgs.winetricks.override { wine = wine; };
  wineEnv = pkgs.myEnvFun {
    name = "wine-gaming";
    buildInputs = [ wine winetricks mesa glxinfo libtxc_dxtn];
    extraCmds = ''
      export LD_LIBRARY_PATH="${mesa}/lib:${libtxc_dxtn}/lib"
      export LIBGL_DRIVERS_PATH="${mesa.drivers}/lib/dri"
      export LIBGL_DEBUG=verbose
      export MESA_DEBUG=1
      export __GL_SYNC_TO_VBLANK=1
    '';
  };
in
{
        environment.systemPackages = [ wineEnv ];
}
