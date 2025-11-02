{ config, pkgs, ... }:

let internalAddress = "172.16.228.1";
in

{
  networking.hostName = "froggy";
  networking.interfaces = {
    enp2s0.useDHCP = true;
    enp3s0.ipv4.addresses = [{
      address = internalAddress;
      prefixLength = 24;
    }];
    wifi1.ipv4.addresses = [{
      address = "172.16.229.1";
      prefixLength = 24;
    }];
  };
  networking.extraHosts = ''
    172.16.228.3 bulldozer bulldozer.home
    172.16.228.9 boomer boomer.home
    172.16.228.7 raptor raptor.home
    172.16.228.10 printer printer.home
    172.16.228.5 viper viper.home
    172.16.228.6 carbon carbon.home
  '';
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "enp3s0" "wifi1" ];
    rejectPackets = true;
    logRefusedPackets = true;
    logRefusedConnections = true;
  };
  networking.nat = {
    enable = true;
    internalInterfaces = [ "enp3s0" "wifi1" ];
    externalInterface = "enp2s0";
  };
  services.hostapd = {
    enable = true;
    #     package = pkgs.stable.hostapd;
    radios.wifi1 = {
      channel = 1;
      networks.wifi1 = {
        ssid = "froggy";
        authentication = {
          mode = "wpa2-sha256";
          wpaPassword = "entropia";
          enableRecommendedPairwiseCiphers = true;
          # pairwiseCiphers = [ "CCMP" "CCMP-256" "GCMP" "GCMP-256" ];
        };
      };
    };
  };
  services.pdns-recursor = {
    enable = true;
    api.address = internalAddress;
    dns.allowFrom = [ "10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16" "127.0.0.0/8" ];
    exportHosts = true;
    yaml-settings = {
      recursor.export_etc_hosts_search_suffix = "home";
    };
  };
  services.kea.dhcp4 = {
    enable = true;
    settings = {
      valid-lifetime = 4000;
      renew-timer = 1000;
      rebind-timer = 2000;
      interfaces-config = {
        interfaces = [ "enp3s0" "wifi1" ];
      };
      lease-database = {
        type = "memfile";
        persist = true;
        name = "/var/lib/kea/dhcp4.leases";
      };
      option-data = [{
        name = "domain-name-servers";
        data = "172.16.228.1";
      }
        {
          name = "domain-name";
          data = "home";
        }];
      subnet4 = [{
        subnet = "172.16.228.0/24";
        id = 228;
        pools = [
          { pool = "172.16.228.129 - 172.16.228.254"; }
        ];
        option-data = [{
          name = "routers";
          data = "172.16.228.1";
        }];
        reservations = [
          {
            #           name = "printer";
            hw-address = "70:5a:0f:13:90:d2";
            ip-address = "172.16.228.10";
          }
          # name = "viper"
          {
            ip-address = "172.16.228.5";
            hw-address = "1c:bf:ce:bd:f1:dd";
          }
          # name = "carbon"
          {
            ip-address = "172.16.228.6";
            hw-address = "00:e0:4d:78:97:ee";
          }
          {
            #           name = "boomer";
            hw-address = "f0:76:1c:d9:b8:06";
            ip-address = "172.16.228.9";
          }
          {
            #           name = "raptor";
            hw-address = "00:21:86:9e:8b:74";
            ip-address = "172.16.228.7";
          }
        ];
      }
        {
          subnet = "172.16.229.0/24";
          id = 229;
          pools = [
            { pool = "172.16.229.129 - 172.16.229.254"; }
          ];
          option-data = [{
            name = "routers";
            data = "172.16.229.1";
          }];
          reservations = [{
            hw-address = "8C:A9:82:A1:E6:50";
            ip-address = "172.16.229.5";
          }];
        }];
    };
  };

  environment.systemPackages = with pkgs; [
    wirelesstools # For debugging
  ];

}
