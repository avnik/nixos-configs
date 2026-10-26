# Neovim Configuration with nvf

## Goal

Replace the shared Vim setup with Neovim configured through nvf. Every user on every host gets a useful base editor; `avn` on `bulldozer` gets a separate, richer profile with broad language and LSP support.

## Approaches

1. Import nvf’s NixOS module and Home Manager module together. Rejected because nvf documentation warns that simultaneous integration methods may cause path collisions.
2. Build separate packages with `nvf.lib.neovimConfiguration`. Use one system package globally and a second package only in `avn`’s Home Manager profile on bulldozer. Chosen because it meets both scopes without importing competing nvf modules.
3. Use only Home Manager. Rejected because users without Home Manager would not receive the base configuration.

## Design

Add nvf as a flake input following the repository’s nixpkgs. Define reusable base and extended nvf configurations in focused Nix modules. The base enables Neovim aliases, sensible editor defaults, search, indentation, UTF-8, and Russian keyboard layout mapping where supported. Install it through the shared console role for all users and hosts, replacing the existing configured Vim package and removing redundant host-specific Neovim installation.

Build the extended package by composing the base configuration with a bulldozer/avn-only module. It will add broad language support and LSP, plus curated modern equivalents for the existing Go, Haskell, Nix, alignment, file-search, status/sign, and undo-tree workflows. Home Manager installs this package only for `avn` on bulldozer and sets `EDITOR`/`VISUAL` to Neovim. Other users retain the base package and defaults.

Update `flake.lock` for nvf. Do not run build, realization, download, or system-configuration commands; verify only with read-only Nix evaluation and syntax/option inspection.

## Acceptance

- Shared base package provides Neovim for all users across all hosts using the console role.
- `avn` on bulldozer receives the extended package; no other user/host receives it.
- `vi`, `vim`, and `nvim` resolve to Neovim where configured; editor variables use Neovim.
- Old Vim package/module is removed and no duplicate host Neovim package remains.
- Read-only evaluation succeeds for representative hosts, and resolved package/profile distinction is verified.

## Decisions

- Preserve only useful editing/search/language behavior, not every legacy Vim setting.
- Extended profile uses broad language and LSP support.
- Chosen integration is standalone nvf package builds to avoid NixOS/Home Manager module collisions.
