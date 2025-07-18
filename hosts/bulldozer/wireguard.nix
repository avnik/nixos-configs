{ config, ...}:
{
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.10.1.2/32" ];
    peers = [
      {
        publicKey = "A4u2Rt5WEMHOAc6YpDABkqAy2dzzFLH9Gn8xWcKaPQQ=";
        allowedIPs = [ "10.10.0.0/16" ];
        endpoint = "vpn.staging.mlabs.city:51820";
        persistentKeepalive = 25;  # Optional
      }
    ];
    privateKeyFile = config.sops.secrets.mlabs-vpn.path; # Using agenix; other options available
  };
}
