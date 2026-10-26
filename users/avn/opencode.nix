{ inputs, pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    settings.skills.paths = [
      "${inputs.caveman}/skills"
      "${inputs.superpowers}/skills"
    ];
    settings.permission.bash = {
      "sudo *" = "deny";
      "su *" = "deny";
      "doas *" = "deny";
      "run0 *" = "deny";
    };
    settings.permission.external_directory = {
      "/home/avn/nixos/nix/**" = "allow";
      "/home/avn/nixos/nixpkgs/**" = "allow";
      "/home/avn/nixos/home-manager/**" = "allow";
      "/home/avn/nixos/nix-sops/**" = "allow";
    };
    context = builtins.readFile ./agent-context.md;
  };
  home.packages = with pkgs; [
    rtk
  ];
}
