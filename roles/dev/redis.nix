{ config, pkgs, ... }:

{
  services.redis = {
    enable = true;
    appendOnly = true;
  };
}
