{ config, pkgs, ... }:

let hammer = pkgs.own.hammer;
    golangEnv = with pkgs; myEnvFun {
      name = "golang";
      buildInputs = [ stdenv glide.bin govers.bin gotools.bin godep go2nix.bin goimports.bin go_1_6 rpm fpm hammer ];
      extraCmds = ''
        unset SSL_CERT_FILE
      '';
  };
in
{
    environment.systemPackages = [ golangEnv ];
}
