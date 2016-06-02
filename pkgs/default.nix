{ pkgs ? (import <nixpkgs> {}) }:

# let's define our own callPackage to avoid typing all dependencies
let 
callPackage = pkgs.lib.callPackageWith (pkgs // own);

own = rec {
    hammer = callPackage ./hammer.nix { goPackages = pkgs.go16Packages; };
};
in
pkgs // {
    inherit own;
}
