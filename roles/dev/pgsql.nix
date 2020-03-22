{ config, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_11;
    superUser = "root";
    logDestination = "csvlog";
    loggingCollector = true;
    extraConfig = ''
      log_statement = 'all'
    '';
  };
}
