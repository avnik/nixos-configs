{ lib, inputs, pkgs, config, nixosConfig, ... }:
let
  modifier = "Mod4";
  hostname = nixosConfig.networking.hostName;
  username = config.home.username;
  homeIcons = "${config.home.homeDirectory}/.nix-profile/share/icons/hicolor";
  homePixmaps = "${config.home.homeDirectory}/.nix-profile/share/pixmaps";
  systemIcons = "/run/current-system/sw/share/icons/hicolor";
  systemPixmaps = "/run/current-system/sw/share/pixmaps";
  iconPath = "${homeIcons}:${systemIcons}:${homePixmaps}:${systemPixmaps}";

  #  swaylock = pkgs.swaylock.overrideAttrs (oa: {
  #    src = inputs.swaylock;
  #    patches = (oa.patches or []) ++ [
  #      ./swaylock-dpms.patch
  #    ];
  #  });
in
{
  imports = [ ./foot.nix ./swayidle.nix ];
  home.packages = with pkgs; [ bemenu slurp grim swappy wayland-utils wlrctl wl-clipboard waypipe wtype tessen ];
  programs = {
    chromium = {
      package = lib.mkForce (pkgs.chromium.override {
        commandLineArgs = lib.concatStringsSep " " config.programs.chromium.commandLineArgs;
      });
      commandLineArgs = [
        "--ozone-platform=wayland"
        "--ozone-platform-hint=auto"
        "--enable-features=WebRTCPipeWireCapturer"
        "--ignore-gpu-blocklist"
        "--enable-gpu-rasterization"
      ];
    };
    fuzzel = {
      enable = true;
      catppuccin.enable = true;
    };
    swaylock = {
      enable = true;
      package = pkgs.swaylock;
    };
  };
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      inherit modifier;
      terminal = "foot";
      bindkeysToCode = true;
      workspaceLayout = "stacking";
      defaultWorkspace = "1";
      keybindings =
        (import ./keybindings.nix { mod = modifier; inherit terminal pkgs lib; sway = true; })
        // {
          "${modifier}+q" = "nop"; # Do nothing on press, trigger on release
          "--release ${modifier}+q" = "exec systemctl kill swayidle.service --user --signal USR1 --kill-who=main";
        };
      focus.wrapping = "yes";
      assigns = {
        "web" = [{ class = "^Firefox$"; }];
        "2" = [{ class = "^Chromium$"; }];
      };
      gaps = {
        smartGaps = false;
        smartBorders = "no_gaps";
      };
      fonts = { names = [ "monospace" ]; size = 11.0; };
      bars = [{
        mode = "dock";
        hiddenState = "show";
        position = "top";
        workspaceButtons = true;
        workspaceNumbers = true;
        statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs /home/${username}/.config/i3status-rust/config-default.toml";
        fonts = { names = [ "monospace" ]; size = 12.0; };
        #          height = 30;
      }];
    };
    extraConfig = ''
      bindsym ${modifier}+Tab focus next
      bindsym ${modifier}+Shift+Tab focus prev

      # I use F12 as en/ru toggle, but chromium still trigger devtools on it (probably by scancode), so don't pass it anywhere
      bindsym --to-code --inhibited F12 nop

      for_window [class="^.*"] border pixel 2
      for_window [app_id="firefox" title="^Picture-in-Picture$"] floating enable
      for_window [shell="xwayland"] title_format "[XWayland] %title"
    '';
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export GDK_BACKEND=wayland
      export CLUTTER_BACKEND=wayland
      export ECORE_EVAS_ENGINE=wayland_egl
      export ELM_ENGINE=wayland_egl
    '';

    systemd.enable = true;
    wrapperFeatures.gtk = true;
  };

  services.wlsunset = {
    enable = true;
    longitude = "54.41";
    latitude = "25.16";
    temperature = {
      night = 6000;
      day = 6500;
    };
    gamma = "1.5";
  };
  services.mako = {
    enable = true;
    settings = {
      layer = "overlay";
      anchor = "bottom-right";
      icons = true;
      max-icon-size = 96;
      max-visible = 3;
      sort = "-time";
      icon-path = iconPath;
    };
  };
}
