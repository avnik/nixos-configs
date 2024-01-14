{ config, pkgs, lib, ... }:

{
    services.openvpn.servers = {
      sghost = {
          config = ''
            dev tun
            remote sg.avnik.info 1194
            fragment 1300
            ifconfig 10.1.0.4 10.1.0.3
            persist-tun
            ping 15
            ping-restart 0
            secret ${./sghost.key}
            data-ciphers AES-256-CBC  
            cipher AES-256-CBC  
          '';
      };
    };
    networking.firewall.allowedUDPPorts = [ 1194 ];
}
