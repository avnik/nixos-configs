# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];


  boot.initrd.availableKernelModules = [ "ahci" "ohci_pci" "ehci_pci" "xhci_hcd" "usb_storage" "usbhid" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [
    "reboot=w,a"
    "cgroup_enable=memory"
    "swapaccount=1"
  ];
  services.libinput.touchpad.disableWhileTyping = true;
  systemd.services.brightness-init = {
      description = "brightness init";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "root";
        Group = "root";
      };
      script = ''
        echo 150 >/sys/class/backlight/amdgpu_bl1/brightness
      '';
  };
}
