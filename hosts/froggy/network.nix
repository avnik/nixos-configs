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
    172.16.228.10 printer
    172.16.228.5 gintaras
  '';
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "enp3s0" "wifi1" ];
    rejectPackets = true;
    logRefusedPackets = false;
    logRefusedConnections = false;
  };
  networking.nat = {
    enable = true;
    internalInterfaces = [ "enp3s0" "wifi1" ];
    externalInterface = "enp2s0";
  };
  services.hostapd = {
    enable = true;
    #     package = pkgs.stable.hostapd;
    radios.wifi1.networks.wifi1 = {
      ssid = "froggy";
      authentication = {
        mode = "wpa2-sha256";
        wpaPassword = "entropia";
        #         enableRecommendedPairwiseCiphers = true;
        pairwiseCiphers = [ "CCMP" "CCMP-256" "GCMP" "GCMP-256" ];
      };
    };
  };
  services.pdns-recursor = {
    enable = true;
    api.address = internalAddress;
    dns.allowFrom = [ "10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16" "127.0.0.0/8" ];
    exportHosts = true;
    settings = {
      export-etc-hosts-search-suffix = "home";
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
          {
            ip-address = "172.16.228.5";
            hw-address = "14:da:e9:0d:b5:0d";
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
  }; /*
   services.dhcpd4 = {
   enable = true;
   interfaces = [ "enp3s0" "wifi1" ];
   extraConfig = ''
       option domain-name-servers 172.16.228.1;
       option domain-name "home";
       subnet 172.16.228.0 netmask 255.255.255.0 {
         option routers 172.16.228.1;
         pool {
           range 172.16.228.129 172.16.228.254;
           max-lease-time 300;
           allow unknown-clients;
         }
       }
       subnet 172.16.229.0 netmask 255.255.255.0 {
         option routers 172.16.229.1;
         option domain-name-servers 172.16.229.1;
         pool {
           range 172.16.229.129 172.16.229.254;
           max-lease-time 300;
           allow unknown-clients;
         }
       }
   '';
   machines = [
       {
           hostName = "printer";
           ethernetAddress = "70:5a:0f:13:90:d2";
           ipAddress = "172.16.228.10";
       }
       {
           hostName = "boomer";
           ethernetAddress = "f0:76:1c:d9:b8:06";
           ipAddress = "172.16.228.9";
       }
       {
           hostName = "raptor";
           ethernetAddress = "00:21:86:9e:8b:74";
           ipAddress = "172.16.228.7";
       }
       {
           hostName = "mobile-olga";
           ethernetAddress = "ac:cf:85:89:ac:f0";
           ipAddress = "172.16.229.3";
       }
       {
           hostName = "mobile-kris";
           ethernetAddress = "14:33:65:1b:f8:24";
           ipAddress = "172.16.229.4";
       }
   ];
   }; */
  environment.systemPackages = with pkgs; [
    wirelesstools
  ];

}
