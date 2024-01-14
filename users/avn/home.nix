{ lib, pkgs, config, inputs, ... }:
{ ... }:

let
  sessionVariables = {
    ###### Packaging (legacy) ##########
    DEBEMAIL = "avn@daemon.hole.ru";
    DEBFULLNAME = "Alexander V. Nikolaev";
    EMAIL = "Alexander V. Nikolaev <avn@avnik.info>";

    ###### locales ########
    LANG = "ru_RU.UTF-8";
    LC_CTYPE = "ru_RU.UTF-8";
    LC_MESSAGES = "C";
    LC_TIME = "C";
    LESSCHARSET = "utf-8";
    EDITOR = "vi";
    VISUAL = "vi";
  };
in

{
  imports = [
    inputs.nix-doom-emacs.hmModule
    ../common/xkb.nix
    ./x11.nix
    ./direnv.nix
    ./emacs.nix
    ./sway.nix
    ./i3status.nix
    ./gpg.nix
  ];

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  services.pass-secret-service = {
    enable = true;
    storePath = "$HOME/.local/share/pass-secret-service-store";
  };
  home.packages = with pkgs; [
    gnome.seahorse # Manager for gnome-keyring
  ];
  programs.powerline-go = {
    enable = true;
    modules = [ "host" "ssh" "cwd" "gitlite" "jobs" "exit" "direnv" "nix-shell" ];
    settings = {
      numeric-exit-codes = true;
      condensed = true;
    };
  };

  programs.zsh = {
    enable = true;
    cdpath = [ "/home/avn" "/home/avn/work" ];
    history = {
      path = "$HOME/.zsh_history";
      ignorePatterns = [ "rm *" "pkill *" ];
    };
    syntaxHighlighting.enable = true;
    sessionVariables = sessionVariables // { };
    initExtra = ''
      autoload -Uz vcs_info
      function precmd {
                  print -nP "\033]2;[zsh@%m:%~]%#\007\033]1;[%m:%~]%#\007"
                  psvar=()
                  vcs_info
                  [[ -n $vcs_info_msg_0_ ]] && psvar[1]="$vcs_info_msg_0_"
      }
      function preexec { local s=''${2//\\/\\\\}; print -nP "\033]2;[zsh@%m:%~]%# $s\007\033]1;[%m:%~]%# $s\007" }
      PS1='[%n@%m:%y]%~%70(l|
      |)%# '
      export PROMPT="[%(!.%S.)%n%(!.%s.)@%m:%y]%~%(?..%B%?%b)%70(l|
      |)%(1v.%F{blue}%1v%f.)%B%#%b "
      reporoot () {
        if git rev-parse --is-inside-git-tree >/dev/null 2>&1; then
          git rev-parse --git-dir | sed -e 's/\/.git$//'
        elif hg root 2>/dev/null; then
          :
        else
          echo $PWD
        fi
      }  
      alias cdroot='cd $(reporoot)'
      bindkey '^R' history-incremental-search-backward
      bindkey -M viins '\e.' insert-last-word
    '';
    historySubstringSearch.enable = true;
    plugins = [
      {
        name = "you-should-use";
        src = pkgs.fetchFromGitHub {
          owner = "MichaelAquilina";
          repo = "zsh-you-should-use";
          rev = "2be37f376c13187c445ae9534550a8a5810d4361";
          sha256 = "0yhwn6av4q6hz9s34h4m3vdk64ly6s28xfd8ijgdbzic8qawj5p1";
        };
      }
    ];
  };

  home.sessionVariables = sessionVariables;
  xdg.configFile."alacritty/alacritty.yml" = { source = ./alacritty.yml; };
  home.stateVersion = "22.05";
}
