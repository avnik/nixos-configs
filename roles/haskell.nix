{ config, pkgs, ... }:

let 
  overrideSrc = pkgs.haskell.lib.overrideSrc;
  addBuildDepends = pkgs.haskell.lib.addBuildDepends;
  doJailbreak = pkgs.haskell.lib.doJailbreak;
  stack = overrideSrc (addBuildDepends (pkgs.haskellPackages.stack.overrideScope (self: super: { Cabal = self.Cabal_2_0_0_2; }))
        [ pkgs.haskellPackages.bindings-uname pkgs.haskellPackages.unliftio ] 
      ) {
    src = pkgs.fetchFromGitHub {
      owner = "commercialhaskell";
      repo = "stack";
      rev = "aa5003a153504f54051e42a844a0c1c3d7f82163";
      sha256 = "1plpdxlmfk3i0s89nwi24mbn9wnmaxwjcyrria4l2r1cnz656rz5";
    };
  };
  stack2nix_ = overrideSrc (addBuildDepends pkgs.stack2nix [ stack ]) {
    src = pkgs.fetchFromGitHub {
      owner = "input-output-hk";
      repo = "stack2nix";
      rev = "ed710c37b126f9766002db72f23886f5e7023969";
      sha256 = "16lvbkbfh0yh3qdm304p2bydnp6pnxg2iksji3z7krwwwfx82iqf";
    };
  };
in

{
  imports = [ ../envs/haskell.nix ];
  environment.systemPackages = with pkgs.haskellPackages; [
    cabal2nix
#    stack2nix
    (doJailbreak stylish-haskell)
  ];
}
