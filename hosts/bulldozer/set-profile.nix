{ lib, pkgs, config, ... }:
with lib;

let
  cfg = config.set-profile;
  script = with pkgs; substituteAll {
    name = "set-profile";
    src = ./set-profile.py;
    dir = "bin";
    isExecutable = true;
    python = python39;
    inherit nix;
  };
in
{
  options.set-profile = {
    enable = mkEnableOption "set-profile";
  };

  config = mkIf cfg.enable {
    system.activationScripts.set-profile = ''
      ${script}/bin/set-profile "$(readlink -f "$systemConfig")" 
    '';
  };
}
