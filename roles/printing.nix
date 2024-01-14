{ config, pkgs, lib, ... }:

{
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    extraConf = ''
      DefaultEncryption Never
    '';
  };
  # prefer ensurePrinters' defined printer over GUI selection
  services.system-config-printer.enable = lib.mkForce false;
  hardware.printers = {
    ensureDefaultPrinter = "printer";
    ensurePrinters = [{
      name = "printer";
      description = "HP m201";
      model = "everywhere";
      deviceUri = "ipp://printer.home/ipp/print";
    }];
  };
}
