{ config, pkgs, inputs, system, ... }:

let
  myShellFunc = { name, buildInputs ? [ ], extraCmds ? "" }: pkgs.myEnvFun {
    inherit name;
    shell = "${pkgs.zsh}/bin/zsh";
    extraCmds = ''
      . ${builtins.getEnv "HOME"}/.zshrc
      ${extraCmds}
    '';
  };

  binutils-stuff = pkgs.runCommand "binutils-stuff" { } ''
    #!${pkgs.stdenv.shell}
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    ln -s ${pkgs.binutils-unwrapped.out}/bin/readelf $out/bin
    ln -s ${pkgs.binutils-unwrapped.out}/bin/strings $out/bin
    ln -s ${pkgs.binutils-unwrapped.out}/share/man/man1/readelf.1.gz $out/share/man/man1/
    ln -s ${pkgs.binutils-unwrapped.out}/share/man/man1/strings.1.gz $out/share/man/man1/
  '';
in

{
  nixpkgs.overlays = [
    (self: super: {
      binutils-stuff = binutils-stuff;
      etxt-antiplagiat = super.pkgsi686Linux.callPackage ./etxt/default.nix { };
      droid-fonts = super.callPackage ./fonts/droid.nix { };
      kerbal = super.callPackage ./kerbal/default.nix { };
      openxcom-extended = super.callPackage ./openxcom/extended.nix { src = inputs.OXCE; };
      gurk = super.callPackage ./gurk { crane = inputs.crane.mkLib self; src = inputs.gurk; };
    })
  ];
}
