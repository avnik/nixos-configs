{ config, pkgs, lib, ... }:

let 
  overrideSrc = pkgs.haskell.lib.overrideSrc;
  addBuildDepends = pkgs.haskell.lib.addBuildDepends;
  doJailbreak = pkgs.haskell.lib.doJailbreak;
  dontCheck = pkgs.haskell.lib.dontCheck;
in let
    haskell = pkgs.haskell // {
    packages = pkgs.haskell.packages // {
      ghc864 = pkgs.haskell.packages.ghc864.override (oldArgs: {
        overrides = lib.composeExtensions (oldArgs.overrides or (_: _: {}))
          (self: super: {

            brittany = doJailbreak (self.callCabal2nix "brittany"
              (pkgs.fetchFromGitHub {
                owner  = "lspitzner";
                repo   = "brittany";
                rev    = "6c187da8f8166d595f36d6aaf419370283b3d1e9";
                sha256 = "0nmnxprbwws3w1sh63p80qj09rkrgn9888g7iim5p8611qyhdgky";
                }) {});

            multistate = dontCheck (doJailbreak super.multistate);
            stylish-haskell = doJailbreak super.stylish-haskell;

          });
      });
    };
  };
  haskellPackages = haskell.packages.ghc864;
in

{
  imports = [ ../envs/haskell.nix ];
  environment.systemPackages = with haskellPackages; [
    brittany
    stack
    (dontCheck intero)
    cabal2nix
#    stack2nix
    stylish-haskell
  ];
}
