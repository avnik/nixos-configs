{ ... }:

{
  # NVIDIA Jetson Orin AGX recovery-mode USB devices.
  # Give avn direct access so flashing tools can run without sudo.
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0955", ATTR{idProduct}=="7023", OWNER="avn", MODE="0660"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0955", ATTR{idProduct}=="7223", OWNER="avn", MODE="0660"
  '';
}
