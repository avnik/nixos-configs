{ config, pkgs, ... }:

{
  # Don't use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    version = 2;
    efiSupport = true;
  };
}
