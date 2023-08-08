# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

with lib;

{
  boot = {
      loader.efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/sda/efi";
      };
      loader.grub = {
        enable = true;
        efiSupport = true;
        mirroredBoots = [
            { devices = [ "nodev" ]; path = "/boot/sda"; efiSysMountPoint = "/boot/sda/efi"; }
            { devices = [ "nodev" ]; path = "/boot/sdb"; efiSysMountPoint = "/boot/sdb/efi"; }
        ];
        memtest86.enable = true;
      };
      kernelParams = [
        "reboot=w,a"
        "radeon.dpm=0"
        "radeon.audio=1"
        "cgroup_enable=memory"
        "swapaccount=1"
        "libata.force=noncq"

      ];
      kernelPackages = pkgs.linuxPackages_5_14;
      #zfs.enableUnstable = true;
      #kernelPackages = pkgs.linuxPackages_latest;
      kernelModules = [ "r8169" ];
  };
  fileSystems = {
     "/boot/efi" = { device = "/dev/sda1"; fsType = "vfat"; };
  };
}
