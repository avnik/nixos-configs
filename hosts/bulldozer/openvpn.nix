{ config, ... }:

{
  services.openvpn.servers = {
    tais = {
      config = ''
        ${builtins.readFile ./verbatim/LE_avnik_tais.ovpn}
      '';
      autoStart = false;
    };
  };
}
