{ config, pkgs, ... }:
{

  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback
  ];

  environment.systemPackages = with pkgs; [
    v4l_utils
    webcamoid
  ];
}
