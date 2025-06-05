# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

with lib;

{
  boot = {
    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/efi";
    };
    loader.systemd-boot.memtest86.enable = true;
    /*
      loader.grub = {
      enable = true;
      efiSupport = true;
      copyKernels = true; 
      mirroredBoots = [
        { devices = [ "nodev" ]; path = "/boot/sda"; efiSysMountPoint = "/boot/sda/efi"; }
        { devices = [ "nodev" ]; path = "/boot/sdb"; efiSysMountPoint = "/boot/sdb/efi"; }
      ];
      memtest86.enable = true;
    }; */
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 2;
    };
    initrd = {
      /*      includeDefaultModules = false;
      availableKernelModules = [
        "sd_mod"
        "ahci"
        "nvme"
        "atkbd"
        "hid-generic" "usbhid" "xhci_pci"
        "zfs"
      ];
      */
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
      "zfs.zfs_arc_max=8589934592"
      "zfs.l2arc_feed_again=0"
      "zfs.zfs_compressed_arc_enable=1"
      #        "zfs.zfs_dbgmsg_enable=0"
      "l2arc_feed_again=0"
    ];
    kernelPackages = pkgs.linuxPackages_6_14;
    zfs.package = pkgs.zfs_2_3;
    #zfs.enableUnstable = true;
    #kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "r8169" ];
  };
  fileSystems = {
    "/efi" = { device = "/dev/disk/by-id/ata-WDC_WD40EFZX-68AWUN0_WD-WX32DB08YNA3-part1"; fsType = "vfat"; };
    #    "/boot/sdb/efi" = { device = "/dev/disk/by-id/ata-WDC_WD40EFZX-68AWUN0_WD-WX32DB08YNA3-part1"; fsType = "vfat"; };
    #    "/boot/sda/efi" = { device = "/dev/disk/by-id/ata-WDC_WD10EFRX-68FYTN0_WD-WCC4J2ZPD560-part1"; fsType = "vfat"; };
  };
}
