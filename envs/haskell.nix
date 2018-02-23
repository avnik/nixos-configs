{ config, pkgs, ... }:

let haskell_ = pkgs.haskellPackages.ghcWithPackages (haskellPackages: with haskellPackages; [
        QuickCheck hspec mtl lens arrows
        Cabal_2_0_1_1 cabal-install stack hlint hpack
        (pkgs.haskell.lib.doJailbreak purescript) 
#        (pkgs.haskell.lib.doJailbreak pkgs.psc-package)
        pkgs.nodejs pkgs.nodePackages.bower
    ]);
    haskellEnv = with pkgs; myEnvFun {
      name = "haskell";
      buildInputs = [ stdenv haskell_ ];
      extraCmds = ''
        unset SSL_CERT_FILE
        eval "$(egrep ^export "$(type -p ghc)")"
      '';
  };
in
{
    environment.systemPackages = [ haskellEnv ];
}
