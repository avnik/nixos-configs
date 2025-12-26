{ config, pkgs, lib, ... }:

{
  services.openvpn.servers = {
  };
  networking.firewall.allowedUDPPorts = [ 1194 ];
}
