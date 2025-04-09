{ config, lib, pkgs, ... }:

with lib;

let
  binaryCaches =
    [
      "http://cache.nixos.org/"
      "https://cache.iog.io"
    ];
  binaryCachePublicKeys =
    [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];

in
{
  nix = {
    settings = {
      sandbox = true;
      cores = 4; # -j4 for subsequent make calls
      max-jobs = 6; # Parallel nix builds
      trusted-users = [
        # "avn"
      ];
      keep-going = false;
      keep-failed = true;
      substituters = binaryCaches;
      trusted-public-keys = binaryCachePublicKeys;
      narinfo-cache-negative-ttl = 0;
      binary-caches-parallel-connections = 10;
      gc-keep-outputs = true;
      gc-keep-derivations = true;
      auto-optimise-store = true ;
    };
    nrBuildUsers = 4;
    extraOptions = ''
    '';
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    nixPath = [
      "nixpkgs=/etc/nixos/nixpkgs"
      "nixos=/etc/nixpkgs/nixos"
      "nixos-config=/etc/nixos/configuration.nix"
    ];
    buildLocation = "/var/buildroot";
  } // lib.optionalAttrs (config.networking.hostName != "bulldozer") {
    gc = {
      automatic = true;
      dates = "05:30";
      options = "--max-freed 5G";
    };
  };
  boot = {
    readOnlyNixStore = true;
  };
}
