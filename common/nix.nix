{ config, lib, pkgs, ... }:
with lib;
{
  nix = {
    useSandbox = true;
    readOnlyStore = true;
    buildCores = 4;    # -j4 for subsequent make calls
#    maxJobs = 2;       # Parallel nix builds
    binaryCaches = lib.optionals (config.networking.hostName != "bulldozer") ["http://bulldozer.home:5000/"] ++ [
#      "http://hydra.nixos.org/"
      "http://cache.nixos.org/"
#      "http://hydra.cryp.to/"
    ];
    binaryCachePublicKeys =  lib.optionals (config.networking.hostName != "bulldozer") [
      "bulldozer.home-1:qpQBqYBCJdEfJv36voiz3Z0MAGxqTPwhCXgzWN9HOIE="
    ] ++ [
#      "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hydra.cryp.to-1:8g6Hxvnp/O//5Q1bjjMTd5RO8ztTsG8DKPOAg9ANr2g="
    ];
    trustedBinaryCaches = [
      "http://hydra.cryp.to/"
    ];
    extraOptions = ''
        gc-keep-outputs = true
        gc-keep-derivations = true
        auto-optimise-store = false
        binary-caches-parallel-connections = 10
    '';
    nixPath = [
        "nixpkgs=/etc/nixos/nixpkgs"
        "nixos=/etc/nixpkgs/nixos"
        "nixos-config=/etc/nixos/configuration.nix"
        "private=/home/avn/nixos/private"
    ];
  };

  systemd.services.nix-daemon = {
      environment.TMPDIR = "/var/buildroot";
      preStart = ''
        mkdir -p /var/buildroot
      '';
  };
}
