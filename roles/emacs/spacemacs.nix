{ stdenv, emacs, fetchFromGitHub
, buildInputs ? [] }:

stdenv.mkDerivation {
  name = "spacemacs";
  src = fetchFromGitHub {
    owner = "syl20bnr";
    repo = "spacemacs";
    rev = "c7a103a772d808101d7635ec10f292ab9202d9ee";
    sha256 = "0g3v64szfvyawcgg9iwkrpkl38caifq35mabchamv44nng4b2bb6";
  };
  buildInputs = [ emacs ] ++ buildInputs;
  preConfigure = ''
    grep defconst init.el >core/core-versions.el
    mv init.el core/spacemacs-init.el
  '';
  buildPhase = ''
    true
  '';
  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp/spacemacs
    cp core/*.el* $out/share/emacs/site-lisp/spacemacs
  '';
  meta = {
    description = "spacemacs";
    descriptionLong = ''
      This version of spacemacs packages for use as support library,
      it not proeprly-packaged as full-featured spacemacs

      (look also for spacemacs-locals, sister-package to extract stuff bundled in layers)
    '';
    homepage = http://spacemacs.org/;
    platforms = stdenv.lib.platforms.all;
  };
}

