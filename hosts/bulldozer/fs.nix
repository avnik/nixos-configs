# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

with lib;
let bindMount = from: { options = [ "bind" ]; fsType = "none"; device = from; };
in
{
  boot = {
    supportedFilesystems = [ "zfs" ];
    #      zfs.enableUnstable = true;
    extraModprobeConfig = "options zfs spa_slop_shift=6";
  };
  fileSystems = {
    "/" = {
      device = "tank/zroot";
      fsType = "zfs";
      options = [ "noatime" "nodiratime" ];
    };
    "/home" = {
      device = "tank/home";
      fsType = "zfs";
      options = [ "noatime" "nodiratime" ];
    };
    "/var/lib/docker" = {
      device = "tank/docker";
      fsType = "zfs";
    };
    "/mnt/data" = {
      device = "tank/data";
      fsType = "zfs";
    };
    "/mnt/raid" = {
      device = "tank/raid";
      fsType = "zfs";
    };
    "/mnt/games" = {
      device = "tank/games";
      fsType = "zfs";
    };
    "/mnt/maildir" = {
      device = "tank/maildir";
      fsType = "zfs";
    };
    "/var/buildroot" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "nosuid" "nodev" "noatime" "nodiratime" ];
    };
    #    "/var/buildroot" = {
    #      device = "tank/buildroot";
    #      fsType = "zfs";
    #    };
    "/mnt/media" = {
      device = "tank/media";
      fsType = "zfs";
    };
    "/mnt/fast" = {
      device = "/dev/bulldozer-secondary/fast";
      fsType = "ext4";
      options = [ "nofail" ];
    };
  };
  swapDevices = [
    { device = "/dev/bulldozer-secondary/swap"; priority = 1; }
    { device = "/dev/disk/by-id/ata-Intenso_SSD_3813430-532012041-part1"; priority = 100; }
  ];
}
