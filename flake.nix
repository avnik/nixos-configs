{
  # flake+deploy-rc based on lovesegfault's:
  # https://github.com/lovesegfault/nix-config/commit/c5be4bc43998d995a96ca8e3006eefb0a059bb05
  description = "avnik's NixOS config";

  inputs = {
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };

    digga = {
      url = "github:divnix/digga";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.deploy.follows = "deploy-rs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.home-manager.follows = "home-manager";
    };
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nixpkgs-wayland  = { 
      url = "github:colemickens/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs.url = "git+file:///home/avn/nixos/nixpkgs";
    
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-21.11";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    whisperfish-nix = {
      url = "path:/home/avn/nixos/whisperfish-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    nix-direnv.url = "github:nix-community/nix-direnv";
    nix-direnv.flake = false;

    ### EMACS, DOOM EMACS
    doom-emacs.url = "github:doomemacs/doomemacs/master";
    doom-emacs.flake = false;
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.flake = false;
    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs/master";
      #inputs.doom-emacs.follows = "doom-emacs";
      #inputs.emacs-overlay.follows = "emacs-overlay";
      inputs.home-manager.follows = "home-manager";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets = {
      url = "path:/home/avn/nixos/secrets";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home.follows = "home-manager";
      inputs.digga.follows = "digga";
      inputs.flake-utils.follows = "flake-utils";
    };
};

  # FIXME: I can't η-reduce this for some reason
  outputs = args: import ./nix/outputs.nix args;
}
