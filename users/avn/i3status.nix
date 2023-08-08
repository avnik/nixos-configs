{ libs, pkgs, config, ... }:
{
  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        settings = {
                theme =  {
                  theme = "solarized-dark";
                  overrides = {
                    idle_bg = "#123456";
                    idle_fg = "#abcdef";
                  };
                };
              };
        blocks = [
         { block ="focused_window"; format="$title.str(max_w:180)|Missing"; }
         { block="load"; format="{1m} {5m} {15m}"; interval=1; }
         {block="memory"; }
         { block="time"; format="$timestamp.datetime(f:'⏰ %F %a %T', l:en_US)"; interval=1;  }
        ];
      };
    };
  };
}

