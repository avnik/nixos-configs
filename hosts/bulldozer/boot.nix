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
        copyKernels = true; /* grub unable to read kernels from /nix/store on zfs, too much hardlinks */
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

        # ZFS stuff
        "elevator=cfq" # noop works bad for me
        "zfs.zfs_arc_max=4294967296"
        "zfs.zfs_vdev_cache_bshift=18"
        "zfs.l2arc_feed_again=0"
        "zfs.zfs_compressed_arc_enable=1"
#        "zfs.zfs_dbgmsg_enable=0"
      ];
      kernelPackages = pkgs.linuxPackages_5_13;
      #zfs.enableUnstable = true;
      #kernelPackages = pkgs.linuxPackages_latest;
      kernelModules = [ "r8169" ];
  };
  fileSystems = {
     "/boot/sda/efi" = { device = "/dev/sda1"; fsType = "vfat"; };
     "/boot/sdb/efi" = { device = "/dev/sdb1"; fsType = "vfat"; };
  };
}
