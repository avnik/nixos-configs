{ config, pkgs, ... }:

let   
myShellFunc = { name, buildInputs ? [], extraCmds ? ""}: pkgs.myEnvFun {
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
    ln -s ${pkgs.binutils.out}/bin/readelf $out/bin
    ln -s ${pkgs.binutils.out}/bin/strings $out/bin
    ln -s ${pkgs.binutils.out}/share/man/man1/readelf.1.gz $out/share/man/man1/
    ln -s ${pkgs.binutils.out}/share/man/man1/strings.1.gz $out/share/man/man1/
    '';
in

{
   nixpkgs.overlays = [
        (self: super: {
            binutils-stuff = binutils-stuff;
            kerbal = super.callPackage ./kerbal.nix {};
        })
   ];
}
