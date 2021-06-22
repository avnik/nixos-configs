{ config, lib, pkgs, ... }:
with lib;
{
  nix = {
    useSandbox = true;
    readOnlyStore = true;
    buildCores = 4;    # -j4 for subsequent make calls
#    maxJobs = 2;       # Parallel nix builds
    nrBuildUsers = 2;
    binaryCaches = lib.optionals (config.networking.hostName != "bulldozer") ["http://bulldozer.home:5000/"] ++ [
      "http://cache.nixos.org/"
    ];
    binaryCachePublicKeys =  lib.optionals (config.networking.hostName != "bulldozer") [
      "bulldozer.home-1:qpQBqYBCJdEfJv36voiz3Z0MAGxqTPwhCXgzWN9HOIE="
    ] ++ [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    trustedUsers = [ "avn" ];
    extraOptions = ''
        gc-keep-outputs = true
        gc-keep-derivations = true
        auto-optimise-store = true 
        binary-caches-parallel-connections = 10
        keep-failed = true
        keep-going = true
    '';
    daemonNiceLevel = 15;
    daemonIONiceLevel = 7;
    nixPath = [
        "nixpkgs=/etc/nixos/nixpkgs"
        "nixos=/etc/nixpkgs/nixos"
        "nixos-config=/etc/nixos/configuration.nix"
        "private=/home/avn/nixos/private"
    ];
    buildLocation = "/var/buildroot";
  };
}
