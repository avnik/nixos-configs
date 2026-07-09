{ ... }:

{
  # Samsung PSSD T7 from dmesg:
  # SerialNumber: S6XDNS0W433013J
  # Make the disk and its partitions accessible to user avn via primary group.
  services.udev.extraRules = ''
    SUBSYSTEM=="block", ENV{ID_SERIAL_SHORT}=="S6XDNS0W433013J", MODE="0660", GROUP="avn"
  '';
}
