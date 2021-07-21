{ self
, deploy-rs
, ...
}@inputs:
let
  inherit (builtins) elemAt mapAttrs;

  mkHost = name: system: import ./mk-host.nix { inherit inputs name system; overlays = self.overlays.${system}; };

  mkPath = name: system: deploy-rs.lib.${system}.activate.nixos (mkHost name system);
in
{
  deploy = {
    autoRollback = true;
    magicRollback = true;
    user = "root";
    nodes = mapAttrs
      (n: v: {
        inherit (v) hostname;
        profiles.system.path = mkPath n v.system;
      })
      (import ./hosts.nix);
  };

  checks = mapAttrs (_: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
}