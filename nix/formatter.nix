{ inputs, ... }:
{
  imports = [
    inputs.flake-root.flakeModule
    inputs.treefmt-nix.flakeModule
  ];
  perSystem =
    { config
    , pkgs
    , ...
    }: {
      treefmt.config = {
        inherit (config.flake-root) projectRootFile;
        package = pkgs.treefmt;
        flakeFormatter = true;
        flakeCheck = true;
        programs = {
          nixpkgs-fmt.enable = true;
          #          prettier.enable = true;
          #          statix.enable = true;
        };
      };

      devshells.default.commands = [
        {
          category = "Tools";
          name = "fmt";
          help = "Format the source tree";
          command = "nix fmt";
        }
      ];
    };
}
