{ config, pkgs, ... }:
{

  boot.extraModulePackages = [
#    config.boot.kernelPackages.v4l2loopback
  ];

#  services.uvcvideo.dynctrl = { 
#    enable = true;
#    packages = [ pkgs.tiscamera ];
#  };

  environment.systemPackages = with pkgs; [
    v4l-utils
#    webcamoid
    motion
#    uvcdynctrl
    uvccapture
    xawtv
  ];
}
