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
        version = 2;
        enable = true;
        efiSupport = true;
        mirroredBoots = [
            { devices = [ "nodev" ]; path = "/boot/sda"; efiSysMountPoint = "/boot/sda/efi"; }
            { devices = [ "nodev" ]; path = "/boot/sdb"; efiSysMountPoint = "/boot/sdb/efi"; }
        ];
      };
      kernelParams = [
        "reboot=w,a"
        "radeon.dpm=0"
        "radeon.audio=1"
        "cgroup_enable=memory"
        "swapaccount=1"

        # ZFS stuff
        "elevator=cfq" # noop works bad for me
        "zfs.zfs_arc_max=2147483648"
        "zfs.zfs_vdev_cache_bshift=18"
        "zfs.zfs_vdev_cache_max=16386"
        "zfs.zfs_vdev_async_read_max_active=12"
        "zfs.zfs_vdev_async_read_min_active=12"
        "zfs.zfs_vdev_async_write_max_active=12"
        "zfs.zfs_vdev_async_write_min_active=12"
        "zfs.zfs_vdev_sync_read_max_active=12"
        "zfs.zfs_vdev_sync_read_min_active=12"
        "zfs.zfs_vdev_sync_write_max_active=12"
        "zfs.zfs_vdev_sync_write_min_active=12"
      ];
      kernelPackages = pkgs.linuxPackages_latest;
      kernelModules = [ "r8169" ];
  };
}
