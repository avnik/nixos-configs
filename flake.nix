{
  # flake+deploy-rc based on lovesegfault's:
  # https://github.com/lovesegfault/nix-config/commit/c5be4bc43998d995a96ca8e3006eefb0a059bb05
  description = "avnik's NixOS config";

  inputs = {
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        naersk.follows = "naersk";
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    naersk = {
      url = "github:nmattia/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs.url = "git+file:///home/avn/nixos/nixpkgs";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # FIXME: I can't η-reduce this for some reason
  outputs = args: import ./nix/outputs.nix args;
}
