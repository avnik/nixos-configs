{
  lib,
  pkgs,
  config,
  ...
}:
let
  types = lib.types;
  gitBin = "${pkgs.git}/bin/git";
  cfg = config.roleplay."git-identity";

  defaultEmail = config.programs.git.settings.user.email or null;

  sanitizeName = value: lib.replaceStrings [ "/" " " ] [ "-" "-" ] value;

  mkInclude = item: {
    path = pkgs.writeText "git-identity-${sanitizeName item.workDir}.cfg" ''
      [user]
        email = "${item.email}"
    '';
    condition = "gitdir:${item.workDir}/**";
  };

  mkCheck = label: repoPath: expected: ''
    label=${lib.escapeShellArg label}
    repo=${lib.escapeShellArg repoPath}
    expected=${lib.escapeShellArg expected}

    if [ ! -d "$repo" ]; then
      echo "WARN git-identity: $label: directory not found: $repo"
    elif ! ${gitBin} -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      echo "WARN git-identity: $label: not a git repository: $repo"
    else
      ident="$(${gitBin} -C "$repo" var GIT_AUTHOR_IDENT 2>/dev/null || true)"
      actual="''${ident#*<}"
      actual="''${actual%%>*}"

      if [ -z "$actual" ]; then
        echo "FAIL git-identity: $label: cannot get email via git var in $repo"
        exit 1
      fi

      if [ "$actual" != "$expected" ]; then
        echo "FAIL git-identity: $label: $repo"
        echo "  expected: $expected"
        echo "  actual:   $actual"
        exit 1
      fi

      echo "OK   git-identity: $label: $repo -> $actual"
    fi
  '';

  additionalChecks = lib.concatMapStringsSep "\n" (
    item: mkCheck "${item.workDir}/${item.repo}" "${item.workDir}/${item.repo}" item.email
  ) cfg.additional;
in
{
  options.roleplay."git-identity" = {
    enable = lib.mkEnableOption "per-workdir git identity includes";
    check = lib.mkEnableOption "git identity activation checks";

    additional = lib.mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            email = lib.mkOption {
              type = types.str;
            };
            workDir = lib.mkOption {
              type = types.str;
            };
            repo = lib.mkOption {
              type = types.str;
            };
          };
        }
      );
      default = [ ];
      example = [
        {
          email = "developer@example.com";
          workDir = "/home/user/work/company";
          repo = "project-a";
        }
      ];
    };

    baseRepo = lib.mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/nixos/configs";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.git.includes = lib.mkAfter (map mkInclude cfg.additional);
    })

    (lib.mkIf cfg.check {
      assertions = [
        {
          assertion = defaultEmail != null && defaultEmail != "";
          message = "roleplay.git-identity.check requires programs.git.settings.user.email";
        }
      ];

      home.activation.gitIdentityChecks = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        echo "Running git identity checks..."
        ${mkCheck "baseRepo" cfg.baseRepo defaultEmail}
        ${additionalChecks}
      '';
    })
  ];
}
