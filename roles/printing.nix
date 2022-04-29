{ config, pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    extraConf = ''
      DefaultEncryption Never
    '';
  };
  hardware.printers = {
    ensureDefaultPrinter = "printer";
    ensurePrinters = [ {
      name = "printer";
      description = "HP m201";
      model = "everywhere";
      deviceUri = "ipp://printer.home/ipp/print";
    } ];
  };
}
