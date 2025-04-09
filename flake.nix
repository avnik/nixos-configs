{
  # flake+deploy-rc based on lovesegfault's:
  # https://github.com/lovesegfault/nix-config/commit/c5be4bc43998d995a96ca8e3006eefb0a059bb05
  description = "avnik's NixOS config";

  inputs = {
    blank.url = "github:divnix/blank";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        stable.follows = "blank";
      };
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    roleplay = {
      url = "path:/home/avn/nixos/roleplay";
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

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs.url = "git+file:///home/avn/nixos/nixpkgs";

    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-23.05";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    nix-direnv = {
      url = "github:nix-community/nix-direnv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hercules-ci.url = "github:hercules-ci/hercules-ci-agent";
    flake-root.url = "github:srid/flake-root";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fast-flake-update = {
      url = "github:Mic92/fast-flake-update";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    nix-fast-build = {
      url = "github:Mic92/nix-fast-build";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    crane.url = "github:ipetkov/crane";  

    OXCE = { url = "github:MeridianOXC/OpenXcom/oxce-plus"; flake = false; };
    gurk = { url = "github:boxdot/gurk-rs?rev=142064844a2151c8c5ac856936ed93e7bb11950c"; flake = false; };
    telegram-desktop-patches = { url = "github:Layerex/telegram-desktop-patches"; flake = false; };

    ### Theming
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-base16 = {
      url = "github:catppuccin/base16";
      flake = false;
    };
    catppuccin-nix = {
      url = "github:catppuccin/nix";
    };
    nix-wallpaper = {
      url = "github:lunik1/nix-wallpaper";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        pre-commit-hooks.follows = "blank";
      };
    };

    ### EMACS, DOOM EMACS
    doom-emacs.url = "github:doomemacs/doomemacs/master";
    doom-emacs.flake = false;
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    nix-doom-emacs = {
      #url = "github:nix-community/nix-doom-emacs/master";
      #url = "github:thiagokokada/nix-doom-emacs/bump-doom-emacs";
      url = "github:marienz/nix-doom-emacs-unstraightened";
      #inputs.doom-emacs.follows = "doom-emacs";
      #inputs.emacs-overlay.follows = "emacs-overlay";
      #inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### Unpublished stuff
    private = {
      url = "path:/home/avn/nixos/secrets";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home.follows = "home-manager";
      inputs.roleplay.follows = "roleplay";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  # FIXME: I can't η-reduce this for some reason
  outputs = inputs: import ./nix/outputs.nix inputs;
}
