{ config, pkgs, ... }:

{
  # Serial numbers visible in dmesg
  # [5205653.969756] usb 2-1.2: new full-speed USB device number 13 using ehci-pci
  # [5205654.056547] usb 2-1.2: New USB device found, idVendor=0403, idProduct=6001, bcdDevice= 6.00
  # [5205654.056550] usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
  # [5205654.056552] usb 2-1.2: Product: TTL232R-3V3
  # [5205654.056553] usb 2-1.2: Manufacturer: FTDI
  # [5205654.056554] usb 2-1.2: SerialNumber: FT9ZOO5E                                                     <-- HERE
  # [5205654.059579] ftdi_sio 2-1.2:1.0: FTDI USB Serial Device converter detected
  # [5205654.059606] usb 2-1.2: Detected FT232RL
  # [5205654.060120] usb 2-1.2: FTDI USB Serial Device converter now attached to ttyUSB4

  services.udev.extraRules = ''
    SUBSYSTEM=="tty" ATTRS{idVendor}=="0403" ATTRS{idProduct}=="6001" ATTRS{serial}=="FT9UAUHT" SYMLINK+="ttyUART-macnica-left" MODE="0666"
    SUBSYSTEM=="tty" ATTRS{idVendor}=="0403" ATTRS{idProduct}=="6001" ATTRS{serial}=="FT9ZONCN" SYMLINK+="ttyUART-macnica-right" MODE="0666"
    SUBSYSTEM=="tty" ATTRS{idVendor}=="0403" ATTRS{idProduct}=="6001" ATTRS{serial}=="FT9ZOO5E" SYMLINK+="ttyCON-macnica-left" MODE="0666"
    SUBSYSTEM=="tty" ATTRS{idVendor}=="0403" ATTRS{idProduct}=="6001" ATTRS{serial}=="FT9ZOO6F" SYMLINK+="ttyCON-macnica-right" MODE="0666"
    SUBSYSTEM=="usb" ATTRS{idVendor}=="0e8d" MODE="0666" GROUP="users"
  '';
  programs.adb.enable = true;
}
