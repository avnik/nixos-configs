# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

with lib;
let bindMount = from: { options = [ "bind" ]; fsType = "none"; device = from; };
in
{
  boot = {
      initrd.availableKernelModules = ["btrfs"];
      supportedFilesystems = [ "zfs" ];
      zfs.enableUnstable = true;
  };
  fileSystems = {
    "/boot/efi1" = { device = "/dev/sda1"; fsType = "vfat"; };
    "/boot/efi2" = { device = "/dev/sdb1"; fsType = "vfat"; };
    "/home"={
        device="tank/home";
        fsType="zfs";
    };
    "/mnt/data"={
        device="tank/data";
        fsType="zfs";
    };
    "/mnt/raid"={
        device="tank/raid";
        fsType="zfs";
    };
    "/mnt/games"={
        device="tank/games";
        fsType="zfs";
    };
    "/mnt/systems" = bindMount "/mnt/data/systems";
    "/mnt/video" = {
        device = "tank/video";
        fsType="zfs";
    };
    "/etc/nixos/nixpkgs" = bindMount "/home/avn/nixos/nixpkgs";
    "/mnt/maildir" = {
        device="tank/maildir";
        fsType="zfs";
    };
    "/var/buildroot" = {
        device="tank/buildroot";
        fsType="zfs";
    };
  };
  swapDevices = [
    { device = "/dev/zvol/tank/swap"; }
  ];
}
