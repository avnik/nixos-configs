{ inputs, ... }:
{
  programs.opencode = {
    enable = true;
    settings.skills.paths = [
      "${inputs.caveman}/skills"
      "${inputs.superpowers}/skills"
    ];
    context = ''
      ## Language policy
      - Don't translate answer to Russian, even if I ask in Russian,
        unless answer is short (1 sentence), or I explicitly ask to give answer in Russian.
      - Use caveman skill

      ## Tools policy
      - Wrap ls/rg/git/cargo/curl with rtk (Example: `rtk git status`)

      ## Trusted Local Repositories

      You may freely read, inspect, and search files in:
      - /home/avn/nixos/nix
      - /home/avn/nixos/nixpkgs
      - /home/avn/nixos/home-manager
      - /home/avn/nixos/nix-sops

      These are near-current repository snapshots and may include local patches.

      ## /nix/store Policy

      - Reading specific files from /nix/store is allowed without asking.
      - Never run broad search across the entire /nix/store.
      - If search is needed, restrict it to explicit subpaths under /nix/store.
    '';
  };
}
