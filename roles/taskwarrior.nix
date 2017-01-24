{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    timewarrior taskwarrior tasknc tasksh khal
  ];
}
