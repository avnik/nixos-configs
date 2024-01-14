{ config, pkgs, ... }:

let
  hammer = pkgs.own.hammer;
  golangEnv = with pkgs; myEnvFun {
    name = "golang";
    buildInputs = [ stdenv go ];
    extraCmds = ''
      unset SSL_CERT_FILE
    '';
  };
in
{
  environment.systemPackages = [ golangEnv ];
}
