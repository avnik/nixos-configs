{ inputs, self, ... }:
let
  inherit (builtins) elemAt mapAttrs attrValues;
  mkHost = name: system: import ./mk-host.nix { inherit inputs name system; overlays = attrValues self.overlays; };
  mkPath = name: system: inputs.deploy-rs.lib.${system}.activate.nixos (mkHost name system);
in
{
  flake = {
    deploy = {
      autoRollback = false;
      magicRollback = true;
      user = "root";
      nodes = mapAttrs
        (n: v: {
          inherit (v) hostname;
          profiles.system.path = mkPath n v.system;
        })
        (import ./hosts.nix);
    };
    nixosConfigurations = mapAttrs
      (n: v: mkPath n v.system)
      (import ./hosts.nix);
  };

  perSystem = { self, ... }:
    {
      #    checks = mapAttrs (_: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
    };
}
