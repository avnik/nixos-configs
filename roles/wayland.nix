{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixpkgs.overlays = [
    # Keep pkgs.xwayland aligned with programs.xwayland.package so NixOS and Home Manager use the same build.
    # Note: changing Xwayland build inputs/flags here also rebuilds wlroots and sway.
    (final: prev: {
      xwayland = prev.xwayland.override {
        defaultFontPath = config.programs.xwayland.defaultFontPath;
      };
    })
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
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
  };

  environment.systemPackages = with pkgs; [
    foot
  ];
}
