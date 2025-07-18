{ inputs, ... }: {
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem =
    { pkgs
    , config
    , inputs'
    , ...
    }: {
      devshells.default = {
        devshell = {
          name = "nix-config";
          motd = ''
            $(type -p menu &>/dev/null && menu)
          '';
        };
        packages = with pkgs; [
          cachix
          nix-build-uncached
          nixpkgs-fmt

          deploy-rs
          inputs'.colmena.packages.colmena
          sops
          ssh-to-pgp
          wireguard-tools
        ];
      };
    };
}
