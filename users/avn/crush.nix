{ inputs, pkgs, ... }:
let
  superpowersSkills = builtins.readDir "${inputs.superpowers}/skills";
  superpowers = builtins.listToAttrs (map (name: {
    inherit name;
    value = "${inputs.superpowers}/skills/${name}";
  }) (builtins.attrNames superpowersSkills));
in
{
  home.packages = with pkgs; [ rtk ];

  programs.crush = {
    enable = true;
    package = pkgs.crush;
    skills = superpowers // {
      caveman = "${inputs.caveman}/skills/caveman";
    };
    settings = {
      models.large = {
        provider = "openai";
        model = "gpt-6-luna";
        reasoning_effort = "medium";
        max_tokens = 128000;
      };
      models.small = {
        provider = "openai";
        model = "gpt-6-luna";
      };
      options.context_paths = [ ./agent-context.md ];
      permissions.allowed_tools = [ "view" "ls" "grep" "edit" "multiedit" "write" "bash" ];
    };
  };
}
