{ inputs, self, lib, ... }:
# FIXME: to be renamed to hosts.nix
{
  flake = {
    nixos = {
      bulldozer = ../hosts/bulldozer;
      froggy = ../hosts/froggy;
      starflyer = ../hosts/starflyer;
      gintaras = ../hosts/gintaras;
    };
    colmena = {
      meta = {
        nixpkgs = import inputs.nixpkgs {
          system = "x86_64-linux";
        };
        machinesFile = "/dev/null";
        specialArgs = {
          inherit inputs;
        };
      };
      defaults = { inputs, pkgs, ... }: {
        _module.args.system = pkgs.stdenv.hostPlatform.system;
        imports = [
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
        ];
      };
      bulldozer = { ... }: {
        deployment = {
          targetHost = "172.16.228.3";
          allowLocalDeployment = true;
        };
        imports = [
          #            inputs.home-manager.nixosModules.home-manager
          #            inputs.sops-nix.nixosModules.sops
          self.nixos.bulldozer
        ];
      };
      froggy = {
        deployment.targetHost = "172.16.228.1";
        imports = [ self.nixos.froggy ];
      };
      starflyer = {
        deployment.targetHost = "172.16.228.4";
        imports = [ self.nixos.starflyer ];
      };
      gintaras = {
        deployment.targetHost = "172.16.228.5";
        imports = [ self.nixos.gintaras ];
      };
    };
  };
}
