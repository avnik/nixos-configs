{ config, pkgs, lib, ... }:

let 
  overrideSrc = pkgs.haskell.lib.overrideSrc;
  addBuildDepends = pkgs.haskell.lib.addBuildDepends;
  doJailbreak = pkgs.haskell.lib.doJailbreak;
  dontCheck = pkgs.haskell.lib.dontCheck;
in let
    haskell = pkgs.haskell // {
    packages = pkgs.haskell.packages // {
      ghc882 = pkgs.haskell.packages.ghc882.override (oldArgs: {
        overrides = lib.composeExtensions (oldArgs.overrides or (_: _: {}))
          (self: super: {

            brittany = doJailbreak (self.callCabal2nix "brittany"
              (pkgs.fetchFromGitHub {
                owner  = "lspitzner";
                repo   = "brittany";
                rev    = "42b9ddaf0f6f59b1bdf2932e946aac923538290f";
                sha256 = "1bs1h0xr1pa7mss6iajis5sgykd6cw655nc38r5dcfd6k26f1rm0";
                }) {});

            multistate = dontCheck (doJailbreak super.multistate);
            stylish-haskell = doJailbreak super.stylish-haskell;

          });
      });
    };
  };
  haskellPackages = haskell.packages.ghc882;
in

{
  imports = [ ../envs/haskell.nix ];
  environment.systemPackages = with pkgs.haskellPackages; [
    stack
    cabal2nix
    ormolu
  ];
}
