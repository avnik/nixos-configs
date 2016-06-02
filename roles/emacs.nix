{ config, pkgs, ... }:

let emacs = pkgs.emacsWithPackages (with pkgs.emacsPackages; with pkgs.emacsPackagesNg; [
    button-lock
    evil
    evil-leader
#    ghc-mod
    haskell-mode
    git-timemachine
    git-auto-commit-mode
    git-gutter
    gitattributes-mode
    gitconfig-mode
    gitignore-mode
    haskell-mode
    helm
    magit
    markdown-mode
    org-plus-contrib
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
