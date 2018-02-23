{ config, pkgs, ... }:

let ocamlEnvF = ocamlPkgs: with pkgs; myEnvFun {
      name = "ocaml-${ocamlPkgs.ocaml.version}";
      buildInputs = with ocamlPkgs; [ stdenv ocaml camlp4 js_of_ocaml ocaml_oasis opam ocamlbuild findlib  ];
      extraCmds = ''
        unset SSL_CERT_FILE
      '';
  };
#  ocamlEnv401 = ocamlEnvF pkgs.ocamlPackages_4_01_0;
  ocamlEnv402 = ocamlEnvF pkgs.ocamlPackages_4_02;
  ocamlEnv403 = ocamlEnvF pkgs.ocamlPackages_4_03;
in
{
    environment.systemPackages = [ ocamlEnv403 ];
}
