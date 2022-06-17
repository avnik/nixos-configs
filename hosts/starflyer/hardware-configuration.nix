# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];


  boot.initrd.availableKernelModules = [ "ahci" "ohci_pci" "ehci_pci" "xhci_hcd" "usb_storage" "usbhid" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [
        "reboot=w,a"
        "radeon.dpm=0"
        "radeon.audio=1"
        "cgroup_enable=memory"
        "swapaccount=1"
        "libata.force=noncq"
        ];
  fileSystems."/" =
    { device = "/dev/disk/by-id/ata-WDC_WD1600BEVS-75RST0_WD-WXE707559895-part3";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-id/ata-WDC_WD1600BEVS-75RST0_WD-WXE707559895-part1";
      fsType = "vfat";
    };

  swapDevices = [
    { device = "/dev/disk/by-id/ata-WDC_WD1600BEVS-75RST0_WD-WXE707559895-part2"; priority = 1; }
  ];

}