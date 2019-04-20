{ config, pkgs, ... }:

let hammer = pkgs.own.hammer;
    golangEnv = with pkgs; myEnvFun {
      name = "golang";
      buildInputs = [ stdenv glide.bin govers.bin go2nix.bin go ];
      extraCmds = ''
        unset SSL_CERT_FILE
      '';
  };
in
{
    environment.systemPackages = [ golangEnv ];
}
