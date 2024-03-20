{ self
, flake-parts
, ...
}@inputs:
flake-parts.lib.mkFlake
{
  inherit inputs;
}
{
  imports = [
    ./formatter.nix
    ./shell.nix
    ./deploy.nix
    ./colmena.nix
  ];
  config = {
    debug = true;
    systems = [ "x86_64-linux" ];
    flake = {
      overlays = {
        emacs = inputs.emacs-overlay.overlay;
        stable = (final: prev: rec {
          #              stable = nixpkgs-stable.legacyPackages.${system};
          #              hercules-ci-cli = hercules-ci.packages.${system}.hercules-ci-cli;
        });
      };
    };

    perSystem = { pkgs, lib, system, ... }:
      let
        inherit (lib) mapAttrs attrValues;
        joinDrvs = pkgs.callPackage ./join-drvs.nix { };
      in
      {
        apps = {
          deploy = {
            type = "app";
            program = "${inputs.deploy-rs.packages."${system}".deploy-rs}/bin/deploy";
          };
        };

        packages = rec {
          default = hosts;
          hosts = joinDrvs "hosts" (mapAttrs (_: v: v.profiles.system.path) self.deploy.nodes);
          #      images = joinDrvs "images" self.images;
        };

        #    checks = (self.legacyPackages.${system}.deploy-rs.lib.deployChecks inputs.self.deploy)
      };
  };
}
