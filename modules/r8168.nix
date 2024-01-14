{ config, pkgs, lib, ... }:

with lib;

let cfg = config.hardware.custom.r8168;
in

{
  options = {
    hardware.custom.r8168.enable = mkOption {
      type = types.bool;
      description = ''
        Replace in-kernel r8169 with r8168
      '';
      default = false;
    };
  };

  config = mkIf cfg.enable {
    boot.extraModulePackages = [ config.boot.kernelPackages.r8168 ];
    boot.blacklistedKernelModules = [ "r8169" ];
  };
}
