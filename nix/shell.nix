{ inputs, ... }: {
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem =
    { pkgs
    , config
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
          nix-linter
          nixpkgs-fmt
          pre-commit

          deploy-rs
          sops
          ssh-to-pgp
        ];

        #    sopsPGPKeyDirs = [
        #      "./keys/hosts"
        #      "./keys/users"
        #    ];

        #    SOPS_GPG_KEYSERVER = "https://keys.openpgp.org";

        #    shellHook = ''
        #      source ${pkgs.sops-pgp-hook}/nix-support/setup-hook
        #      sopsPGPHook
        #    '';
      };
    };
}
