{ lib, pkgs, config, ... }:
with lib;

let
  cfg = config.set-profile;
  script = with pkgs; replaceVarsWith {
    src = ./set-profile.py;
    dir = "bin";
    isExecutable = true;
    replacements = {
      python = python3;
      inherit nix;
    };
  };
in
{
  options.set-profile = {
    enable = mkEnableOption "set-profile";
  };

  config = mkIf cfg.enable {
    system.activationScripts.set-profile = ''
      ${script}/bin/set-profile.py "$(readlink -f "$systemConfig")" 
    '';
  };
}
