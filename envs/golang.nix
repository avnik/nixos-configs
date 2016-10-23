{ config, pkgs, ... }:

let hammer = pkgs.own.hammer;
    golangEnv = with pkgs; myEnvFun {
      name = "golang";
      buildInputs = [ stdenv glide.bin govers.bin godep go2nix.bin goimports.bin go rpm fpm ];
      extraCmds = ''
        unset SSL_CERT_FILE
      '';
  };
in
{
    environment.systemPackages = [ golangEnv ];
}
