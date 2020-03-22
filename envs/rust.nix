{ config, pkgs, ... }:
let rustEnv = with pkgs; myEnvFun {
  name = "rust";
  buildInputs = [
    rustc
    cargo
    carnix
#    cargo-edit
    cargo-release
    cargo-tree
  ];
  extraCmds = ''
    unset SSL_CERT_FILE
  '';
};
in

{
    environment.systemPackages =  [ rustEnv ];
}
