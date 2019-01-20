{ symlinkJoin, callPackage, writeShellScriptBin, mono }:

let
    kerbal = callPackage ./kerbal.nix {};
    kerbal-mod-manager = callPackage ./kerbal-mod-manager.nix {};
    ckan_ = writeShellScriptBin "kerbal-ckan" 
      ''
        ${mono}/bin/mono ~/kerbal/CKAN/CKAN.exe
      '';
in

symlinkJoin {
  name = "kerbal";
  paths = [ kerbal kerbal-mod-manager ckan_ ];
}
