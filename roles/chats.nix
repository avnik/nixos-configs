{ config, inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    telegram-desktop
    # Unused for years
    zoom-us
    ## Matrix
    # fractal-next

    gurk-rs
    # signal-desktop
    # element-desktop
  ];
}
