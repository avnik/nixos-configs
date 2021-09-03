{ libs, pkgs, config, ... }:
{
  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        settings = {
                theme =  {
                  name = "solarized-dark";
                  overrides = {
                    idle_bg = "#123456";
                    idle_fg = "#abcdef";
                  };
                };
              };
        blocks = [
         { block ="focused_window"; max_width=200; }
         { block="load"; format="{1m} {5m} {15m}"; interval=1; }
         {block="memory"; }
         { block="time"; format="⏰ %F %a %T"; interval=1; locale="en_US"; }
        ];
      };
    };
  };
}

