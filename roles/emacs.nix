{ config, pkgs, ... }:

let emacs = pkgs.emacsWithPackages (with pkgs.emacsPackages; with pkgs.emacsPackagesNg; [
    # configuration stuff
    bind-key
    use-package
    use-package-chords

    #FUN
    achievements
    annoying-arrows-mode

    #common important stuff
    mmm-mode
    mouse3
    with-editor
    doremi doremi-frm doremi-cmd
    fullframe
    super-save
    aggressive-indent
    golden-ratio
    m-buffer
    iflipb
    edit-server


    #HELM
    helm
    helm-descbinds
    helm-describe-modes
    helm-cmd-t
    helm-swoop
    

    yasnippet
    yankpad

    #NOTMUCH
    notmuch
    notmuch-labeler
    helm-notmuch

    #elfeed
    elfeed

    #MISC modes
    markdown-mode
    ssh-config-mode
    gitattributes-mode
    gitconfig-mode
    gitignore-mode
    nix-mode
    fvwm-mode
    yaml-mode
    ansible
    jinja2-mode 
    web-mode
    multi-web-mode
    js2-mode
    auto-indent-mode
    editorconfig-custom-majormode
    editorconfig
    rainbow-mode
    rainbow-delimiters
    csv-mode

    ##
    button-lock
    company
    company-nixos-options
    rainbow-delimiters
    undo-tree
    smartparens

    #THEMING
    color-theme
    badwolf-theme
    graphene-meta-theme
    dark-mint-theme
    abyss-theme

    # EVIL
    evil
    evil-leader
    evil-org

    # GIT
    git-timemachine
    git-auto-commit-mode
    git-gutter
    magit
    magit-annex
    magit-find-file
    magit-rockstar
    magit-topgit
    magit-gitflow
    magit-gh-pulls
    magit-filenotify
    github-issues
    gitlab

    #FLY
    flyspell-lazy

    # ORG
    org-plus-contrib
    org-gnome
    org-password-manager
    org-attach-screenshot
    org-autolist
    org-capture-pop-frame
    org-projectile
    org-redmine
    org-time-budgets
    org-vcard
    orgit

    #auto complete
    auto-complete
    ac-helm

    # Projectile
    projectile
    perspective
    helm-projectile
    persp-projectile
    projectile-direnv
    project-persist-drawer
    ppd-sr-speedbar


    #DOCKER
    dockerfile-mode
    docker-tramp

    #GO
    go-mode
#    go-projectile
    go-stacktracer
    go-gopath
    go-snippets
    go-direx

    #HASKELL
    #ghc-mod
    hamlet-mode
    haskell-mode
    company-cabal
    #company-ghc
    #company-ghci
    #intero

    #ELM
    elm-mode
    elm-yasnippets

    #LUA
    flymake-lua
    lua-mode
]);
in {
    environment.systemPackages = [
        emacs
    ];
}
