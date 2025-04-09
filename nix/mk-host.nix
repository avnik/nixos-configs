{ inputs
, name
, system
, overlays
, extraModules ? [ ]
}:
let
  inherit (nixpkgs.lib) pathExists optionalAttrs;
  inherit (builtins) attrNames readDir;
  inherit (inputs) nixpkgs impermanence home-manager sops-nix;

  config = {
    allowUnfree = true;
    allowAliases = true;
  };

in
nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    ({ nixpkgs = { inherit config; overlays = overlays; }; })
    impermanence.nixosModules.impermanence
    home-manager.nixosModules.home-manager
    sops-nix.nixosModules.sops

    (../hosts + "/${name}")
  ] ++ extraModules;

  specialArgs.inputs = inputs;
  specialArgs.system = system;
}
