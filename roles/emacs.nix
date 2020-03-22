{ config, pkgs, ... }:

let
  customEmacs = pkgs.emacsPackagesNg.overrideScope' (self: super: with self; rec {
        # use a custom version of emacs (remacs sometimes?)
        # emacs = ...;
        # Customized stuff 
        spacemacs = self.callPackage ./emacs/spacemacs.nix { };
        fromSpace = { layer, source, buildInputs ? [] }: 
          self.callPackage ./emacs/spacemacs-locals.nix { spacemacs = spacemacs; buildInputs = buildInputs; fromLayer = layer; sourcePackage = source; };
          
        hybrid-mode = fromSpace { layer = "+distributions/spacemacs-base"; source = "hybrid-mode"; buildInputs = [ evil evilified-mode ]; };
        holy-mode = fromSpace { layer = "+distributions/spacemacs-base"; source = "holy-mode"; buildInputs = [ evil evilified-mode ]; };
        evilified-mode = fromSpace { layer = "+distributions/spacemacs-base"; source = "evil-evilified-state"; buildInputs = [ evil bind-map evil-surround ]; };
        centered-buffer-mode = fromSpace { layer = "+distributions/spacemacs-base"; source = "centered-buffer-mode"; buildInputs = [ evil ]; };
        help-fns = fromSpace { layer = "+distributions/spacemacs-base"; source = "help-fns+"; buildInputs = [ ]; };
        spacemacs-whitespace-cleanup = fromSpace { layer = "+spacemacs/spacemacs-editing"; source = "spacemacs-whitespace-cleanup"; buildInputs = [ ]; };
        spacemacs-evil-unimpaired = fromSpace { layer = "+spacemacs/spacemacs-evil"; source = "evil-unimpaired"; buildInputs = [ f s dash evil ]; };
        space-doc = fromSpace { layer = "+spacemacs/spacemacs-org"; source = "space-doc"; buildInputs = [ centered-buffer-mode ]; };
        spacemacs-info = fromSpace { layer = "+spacemacs/spacemacs-ui"; source = "info+"; buildInputs = [ ]; };
        centered-cursor = fromSpace { layer = "+spacemacs/spacemacs-ui"; source = "centered-cursor"; buildInputs = [ ]; };
        zoom-frm = fromSpace { layer = "+spacemacs/spacemacs-ui-visual"; source = "zoom-frm"; buildInputs = [ ]; };


  });
in
let emacs = customEmacs.emacsWithPackages (epkgs: with epkgs; [
    # configuration stuff
#    bind-key
#    bind-map
#    use-package
#    use-package-chords

    # outer space stuff (unbundled libraries)
#    help-fns
#    centered-buffer-mode
#    hybrid-mode
#    holy-mode
#    evilified-mode
#    spacemacs-whitespace-cleanup
#    spacemacs-evil-unimpaired
#    space-doc
#    spacemacs-info
#    centered-cursor
#    zoom-frm

#    spacemacs-theme # this one always was unbundled
    # outer space ends here

    # some ex-spacemacs deps (core/libs)
#    ido-vertical-mode
#    ht
#    page-break-lines
#    delight
#    hydra
#    async
#    request
#    dumb-jump
#    pcre2el
#    undo-tree
#    # end ex-space deps

    # doom dependencies
#    async
#    persistent-soft
#    quelpa
    #

    # look and ...
#    alert
#    all-the-icons
#    spaceline
#    which-key

    #...and feel
#    no-littering
#    sackspace
#    smex
#    ace-window
#    super-save

#    mwim    # borrowed from spacemacs better defaults
#    unfill  # ^^

    # EVIL
#    evil
#    evil-args
#    evil-anzu
#    evil-collection
#    evil-commentary
#    evil-embrace
#    evil-indent-plus
#    evil-indent-textobject
#    evil-ledger
#    evil-multiedit
#    evil-nerd-commenter
#    evil-numbers
#    evil-org
#    evil-smartparens
#    evil-surround
#    general

    #FUN
#    achievements
#    annoying-arrows-mode

    #common important stuff
#    mmm-mode
#    with-editor
#    fullframe
#    super-save
#    aggressive-indent
#    golden-ratio
#    m-buffer
#    iflipb
#    edit-server


    #HELM
#    helm
#    helm-descbinds
#    helm-describe-modes
#    helm-cmd-t
#    helm-swoop
    
    ## Swiper
#    ivy
#    counsel
#    swiper
#    ivy-todo



#    yasnippet
#    yankpad

    #NOTMUCH
#    notmuch
#    notmuch-labeler
#    helm-notmuch

    #elfeed
#    elfeed

    #MISC modes
#    markdown-mode
#    ssh-config-mode
#    gitattributes-mode
#    gitconfig-mode
#    gitignore-mode
#    nix-mode
#    fvwm-mode
#    yaml-mode
#    ansible
#    jinja2-mode 
#    web-mode
#    multi-web-mode
#    js2-mode
#    auto-indent-mode
#    editorconfig-custom-majormode
#    editorconfig
#    rainbow-mode
#    rainbow-delimiters
#    csv-mode
#    ledger-mode

    ##
#    button-lock
#    company
#    company-emoji
#    company-nixos-options
#    rainbow-delimiters
#    smartparens

    #THEMING
#    color-theme
#    badwolf-theme
#    graphene-meta-theme
#    dark-mint-theme
#    abyss-theme

    # GIT
#    git-timemachine
#    git-auto-commit-mode
#    git-gutter
#    magit
#    magit-annex
#    magit-gitflow
#    github-issues
#    gitlab

    #FLY
#    flyspell-lazy

    # ORG
#    org-plus-contrib

    # ORG plugins
#    org-attach-screenshot
#    org-autolist
#    org-bullets
#    org-capture-pop-frame
#    org-caldav
#    org-clock-convenience
#    org-download
#    org-gnome
#    org-fancy-priorities
#    org-journal
#    org-kanban
#    org-mime
#    org-password-manager
#    org-pomodoro
#    org-projectile
#    org-projectile-helm
#    org-redmine
#    org-time-budgets
#    org-super-agenda
#    org-vcard
#    orgit

    #auto complete
#    auto-complete
#    ac-helm

    # Projectile
#    projectile
#    perspective
#    helm-projectile
#    persp-projectile
#    projectile-direnv
#    project-persist-drawer
#    ppd-sr-speedbar

    # SAURON! (More evil powers)
#    sauron

    #DOCKER
#    dockerfile-mode
#    docker-tramp

    #GO
#    go-mode
#    go-stacktracer
#    go-gopath
#    go-snippets
#    go-direx

    #HASKELL
    #ghc-mod
#    hamlet-mode
#    haskell-mode
#    company-cabal
    #company-ghc
    #company-ghci
    #intero

    #LUA
#    flymake-lua
#    lua-mode
]);
in {
    environment.systemPackages = [
        emacs
    ];
    fonts.fonts = with pkgs;  [
        emacs-all-the-icons-fonts
    ];
}
