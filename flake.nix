{
  # flake+deploy-rc based on lovesegfault's:
  # https://github.com/lovesegfault/nix-config/commit/c5be4bc43998d995a96ca8e3006eefb0a059bb05
  description = "avnik's NixOS config";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        stable.follows = "";
        nix-github-actions.follows = ""; # Unneeded, and pull own nixpkgs revision
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
      inputs.flake-utils.follows = "flake-utils";
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

    # I use SOPS in my own personal projects and some customers'
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # I didn't use agenix myself, but some my customers are, and I need actual cli
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-direnv = {
      url = "github:nix-community/nix-direnv";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };

    hercules-ci = {
      url = "github:hercules-ci/hercules-ci-agent";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
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
    nix-update = {
      url = "github:Mic92/nix-update";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    crane.url = "github:ipetkov/crane";

    OXCE = {
      url = "github:MeridianOXC/OpenXcom/oxce-plus";
      flake = false;
    };
    gurk = {
      url = "github:boxdot/gurk-rs";
      flake = false;
    };
    telegram-desktop-patches = {
      url = "github:Layerex/telegram-desktop-patches";
      flake = false;
    };
    opencode = {
      url = "github:anomalyco/opencode";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### Theming
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
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
        pre-commit-hooks.follows = "";
      };
    };

    ### EMACS, DOOM EMACS
    #doom-emacs.url = "github:doomemacs/doomemacs/f3b4314ddaf8f7253283f4bb001432fab8459f00";
    #doom-emacs.flake = false;
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    nix-doom-emacs = {
      #url = "github:nix-community/nix-doom-emacs/master";
      #url = "github:thiagokokada/nix-doom-emacs/bump-doom-emacs";
      url = "github:marienz/nix-doom-emacs-unstraightened";
      #inputs.doom-emacs.follows = "doom-emacs";
      #inputs.emacs-overlay.follows = "emacs-overlay";
      #inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.doomemacs.follows = "doom-emacs";
    };

    disko = {
      url = "github:nix-community/disko";
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
