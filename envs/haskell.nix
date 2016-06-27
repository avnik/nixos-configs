{ config, pkgs, ... }:

let haskell_ = pkgs.ghcWithHoogle (haskellPackages: with haskellPackages; [
        QuickCheck hspec mtl lens arrows
        cabal-install stack cabal2nix
    ]);
    haskellEnv = with pkgs; own.myShellFun {
      name = "haskell";
      buildInputs = [ stdenv haskell_ ];
      extraCmds = ''
        unset SSL_CERT_FILE
        eval "$(egrep ^export "$(type -p ghc)")"
      '';
  };
in
{
    environment.systemPackages = [ haskellEnv];
}
