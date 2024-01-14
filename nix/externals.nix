{ config ? { }
, system ? builtins.currentSystem
, crossSystem ? null
, sourcesOverride ? { }
  # Set application for getting a specific application nixkgs-src.json
, application ? ""
  # Override nixpkgs-src.json to a file in your repo
, nixpkgsOverride ? ""
, nixpkgsJsonOverride ? ""
  # Modify nixpkgs with overlays
, nixpkgsOverlays ? [ ]
, defaultSources ? import ./sources.nix
, pkgsDefault ? import defaultSources.nixpkgs { inherit config system crossSystem; }
}:

let
  sources-boot = defaultSources // sourcesOverride;
  iohk-nix-boot = import sources-boot.iohk-nix { inherit pkgsDefault sourcesOverride nixpkgsOverlays config system crossSystem; };
  sources = iohk-nix-boot.sources // sources-boot // { nixpkgs = pkgsDefault; };

  inherit (import defaultSources.niv { pkgs = pkgsDefault; }) niv;

  iohk-nix = import sources.iohk-nix { inherit pkgsDefault sourcesOverride nixpkgsOverlays config system crossSystem; defaultSources = sources; };
  self = rec {
    inherit (iohk-nix)
      overlays
      sources
      niv
      shell
      tests
      rust-packages
      haskell-nix-extra-packages
      # package sets
      nixpkgs
      pkgs
      pkgsDefault;
  };
in
self
