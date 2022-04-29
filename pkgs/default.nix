{ config, pkgs, inputs, system, ... }:

let   
myShellFunc = { name, buildInputs ? [], extraCmds ? ""}: pkgs.myEnvFun {
    inherit name;
    shell = "${pkgs.zsh}/bin/zsh";
    extraCmds = ''
      . ${builtins.getEnv "HOME"}/.zshrc
      ${extraCmds}
    '';
};
/*
whisperfish = let
     naersk-lib = inputs.naersk.lib."${system}";
  in naersk-lib.buildPackage {
    name = "whisperfish";
    version = "devel";
    src = inputs.whisperfish;
    usePureFromTOML = false;
    allRefs = true;
    buildInputs = with pkgs; [ dbus pkgconfig ];

    # needed for internal protobuf c wrapper library
    PROTOC = "${pkgs.protobuf}/bin/protoc";
    PROTOC_INCLUDE = "${pkgs.protobuf}/include";
  };
*/

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
            etxt-antiplagiat = super.pkgsi686Linux.callPackage ./etxt/default.nix {};
            droid-fonts = super.callPackage ./fonts/droid.nix {};
            kerbal = super.callPackage ./kerbal/default.nix {};
            terraria = super.callPackage ./gamesteam.nix {
              gameName = "terraria";
              gameDir = "terraria";
              gameExecutable = "Terraria";
            };
            openxcom-extended = super.callPackage ./openxcom/extended.nix {};
            inherit (inputs.whisperfish-nix.packages.${system}) whisperfish gurk;
        })
   ];
}
