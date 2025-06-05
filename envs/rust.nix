{ inputs, config, pkgs, ... }:
let
  rustEnv = with pkgs; myEnvFun {
    name = "rust";
    buildInputs = [
      gcc
      protobuf
      (inputs.rust-overlay.packages.${pkgs.stdenv.system}.default.override {
        targets = [ "x86_64-unknown-linux-gnu" "x86_64-pc-windows-gnu" "x86_64-apple-darwin" ];
      })
      #    cargo-edit
      cargo-hack
    ];
    extraCmds = ''
      unset SSL_CERT_FILE
    '';
  };
in

{
  environment.systemPackages = [ rustEnv ];
}
