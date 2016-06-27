{ config, pkgs, ... }:

let emacs = pkgs.emacsWithPackages (with pkgs.emacsPackages; with pkgs.emacsPackagesNg; [
    # configuration stuff
    bind-key
    use-package
    use-package-chords
    achievements

    button-lock
    company
    company-nixos-options
    company-cabal
    company-ghc
    company-ghci

    color-theme
    evil
    evil-leader
    ghc-mod

    git-timemachine
    git-auto-commit-mode
    git-gutter
    gitattributes-mode
    gitconfig-mode
    gitignore-mode
    hamlet-mode
    haskell-mode
    helm
    magit
    markdown-mode
    mouse3

    # ORG
    org-plus-contrib
    org-gnome
    org-password-manager

    projectile
    perspective
    helm-projectile
    persp-projectile
    rainbow-delimiters
    undo-tree
]);
in {
    environment.systemPackages = [
        emacs
    ];
}
