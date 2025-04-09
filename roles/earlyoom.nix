{
  services.earlyoom = {
    enable = true;
    extraArgs = [ "--avoid" "(^|/)(systemd|X|sway|xfwm4|xfce4\-session|firefox)" "--prefer" "^Isolated Web Container$" ];
  };
  systemd = {
    user.extraConfig = "DefaultOOMScoreAdjust=0";
    services."user@".serviceConfig.OOMScoreAdjust = 0;
  };
}
