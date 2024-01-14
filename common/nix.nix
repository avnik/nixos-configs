{ config, lib, pkgs, ... }:

with lib;

let
  binaryCaches =
    [
      "http://cache.nixos.org/"
    ];
  binaryCachePublicKeys =
    [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

in
{
  nix = {
    settings = {
      sandbox = true;
      cores = 4; # -j4 for subsequent make calls
      max-jobs = 6; # Parallel nix builds
      trusted-users = [ "avn" ];
      substituters = binaryCaches;
      trusted-public-keys = binaryCachePublicKeys;
    };
    nrBuildUsers = 4;
    extraOptions = ''
      gc-keep-outputs = true
      gc-keep-derivations = true
      auto-optimise-store = true 
      binary-caches-parallel-connections = 10
      keep-failed = true
      keep-going = true
    '';
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    nixPath = [
      "nixpkgs=/etc/nixos/nixpkgs"
      "nixos=/etc/nixpkgs/nixos"
      "nixos-config=/etc/nixos/configuration.nix"
      "private=/home/avn/nixos/private"
    ];
    buildLocation = "/var/buildroot";
  };
  boot = {
    readOnlyNixStore = true;
  };
}
