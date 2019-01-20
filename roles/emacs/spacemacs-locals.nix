{ stdenv, emacs, spacemacs
, fromLayer
, sourcePackage
, buildInputs ? [] }:

stdenv.mkDerivation {
  name = "spacemacs-locals-${builtins.replaceStrings ["/"] ["-"] fromLayer}-${sourcePackage}";
  src = spacemacs.src;
  buildInputs = [ emacs ] ++ buildInputs;
  unpackPhase = ''
      cp -rv --no-preserve=mode $src/layers/${fromLayer}/local/${sourcePackage} .
  '';
  buildPhase = ''
    ARGS=$(find ${stdenv.lib.concatStrings
            (builtins.map (arg: arg + "/share/emacs/site-lisp ") buildInputs)} \
            -type d -exec echo -L {} \;)
    ${emacs}/bin/emacs -Q -nw -L . $ARGS --batch -f batch-byte-compile ${sourcePackage}/*.el
  '';
  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp/${sourcePackage}
    cp ${sourcePackage}/*.el* $out/share/emacs/site-lisp/${sourcePackage}
  '';
}

