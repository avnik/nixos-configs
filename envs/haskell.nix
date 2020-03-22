{ config, pkgs, ... }:

let haskell_ = pkgs.haskellPackages.ghcWithPackages (haskellPackages: with haskellPackages; [
        QuickCheck hspec mtl lens arrows
    ]);
    addons = with pkgs.haskellPackages; [
#        (pkgs.haskell.lib.doJailbreak (purescript.overrideScope (self: super: { spdx = pkgs.haskell.lib.doJailbreak super.spdx; }))#) 
#        (pkgs.haskell.lib.doJailbreak pkgs.psc-package)
        pkgs.nodejs pkgs.nodePackages.bower
        cabal-install hlint hpack
        stack
        ];
    haskellEnv = with pkgs; myEnvFun {
      name = "haskell";
      buildInputs = [ stdenv haskell_ ] ++ addons;
      extraCmds = ''
        unset SSL_CERT_FILE
        eval "$(egrep ^export "$(type -p ghc)")"
      '';
  };
in
{
    environment.systemPackages = [ haskellEnv ];
}
