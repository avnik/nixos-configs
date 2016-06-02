{ config, pkgs, ... }:

let golangEnv = with pkgs; myEnvFun {
      name = "golang";
      buildInputs = [ stdenv go16Packages.glide.bin go_1_6 rpm fpm own.hammer ];
  };
in
{
    environment.systemPackages = [ golangEnv ];
}
