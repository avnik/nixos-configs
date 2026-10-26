{ config, pkgs, lib, ... }: {
  # Enable OpenGL / hardware graphics
  hardware.graphics.enable = true;

  # Enable Nvidia driver in Xserver/Wayland
  services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required for most compositors and Wayland
    modesetting.enable = true;

    # GT 1030 does not support the open-source kernel modules
    open = false;

    # Enable nvidia-settings menu
    nvidiaSettings = true;

    # Use the stable or production package branch
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };
}
