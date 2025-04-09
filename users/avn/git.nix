{ pkgs, ... }:
let
  /* Following statements very hard to convert to ini style settings, include them bare */
  insteadOf = pkgs.writeText "instead-of.cfg" ''
    [url "git://github.com/ghc/packages-"]
        insteadOf = git://github.com/ghc/packages/
    [url "http://github.com/ghc/packages-"]
        insteadOf = http://github.com/ghc/packages/
    [url "https://github.com/ghc/packages-"]
        insteadOf = https://github.com/ghc/packages/
    [url "ssh://git@github.com/ghc/packages-"]
        insteadOf = ssh://git@github.com/ghc/packages/
    [url "git@github.com:ghc/packages-"]
        insteadOf = git@github.com:ghc/packages/
  '';
  credentialHelpers = pkgs.writeText "credentials.cfg" ''
    [credential "https://github.com"]
        helper =
        helper = ${pkgs.gh}/bin/gh auth git-credential
    [credential "https://gist.github.com"]
        helper =
        helper = ${pkgs.gh}/bin/gh auth git-credential
  '';
  additionalUsername' = pkgs.writeText "username.cfg" ''
    [user]
        name = "Alexander Nikolaev"
        email = "alexander.nikolaev@unikie.com"
  '';
  additionalUsername = pkgs.writeText "username.cfg" ''
    [includeIf "hasconfig:remote.*.url:https://github.com/tiiuae/**"]
      path = ${additionalUsername'}
  '';
in
{
  programs.git = {
    enable = true;
    userEmail = "avn@avnik.info";
    userName = "Alexander V. Nikolaev";
    ignores = [ ".envrc" ".direnv" ".shell.nix" ".avn" "*~" ".#*" "#*#" ];
    signing = {
      signByDefault = true;
      key = "0xB8AF18ABCA6271D2";
    };
    extraConfig = {
      core.pager = "${pkgs.delta}/bin/delta";
      interactive.diffFilter = "${pkgs.delta}/bin/delta --color-only";
      delta = {
        navigate = true;
        dark = true;
      };
      pack.threads = 16;
      pull.rebase = true;
      rebase.squash = true;
      merge.conflictStyle = "zdiff3";
      sendemail = {
        confirm = "never";
        assume8bitEncoding = "utf-8";
        suppressfrom = "true";
        suppresscc = "self";
      };
      format.numbered = true;
      sequence.editor = "${pkgs.git-interactive-rebase-tool}/bin/interactive-rebase-tool";
    };
    includes = [
      { path = insteadOf; }
      { path = credentialHelpers; }
      { path = additionalUsername; }
    ];
  };
}

