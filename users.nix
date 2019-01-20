{ config, pkgs, ...}:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.avn = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = ["audio" "docker" "pulse" "video" "render" "wheel" "vboxusers"];
    shell = "/run/current-system/sw/bin/zsh";
  };
  users.extraUsers.olga = {
    isNormalUser = true;
    uid = 1001;
    shell = "/run/current-system/sw/bin/zsh";
  };
  users.extraUsers.kris = {
    isNormalUser = true;
    uid = 1002;
    shell = "/run/current-system/sw/bin/zsh";
    extraGroups = [ "docker" "pulse" "video" "render" ];
  };
}
