{ inputs, lib, ... }:
let
  patches = builtins.map
    (x: "${inputs.telegram-desktop-patches}/${x}")
    (builtins.filter (lib.hasSuffix ".patch") (builtins.attrNames (builtins.readDir inputs.telegram-desktop-patches)));
in
{
  config.flake = {
    overlays = {
      /*
      telegram = (final: prev: {
        telegram-desktop = prev.telegram-desktop.override {
          unwrapped = prev.telegram-desktop.unwrapped.overrideAttrs (oa: {
            patches = (oa.patches or []) ++ patches;
          });
        };
      });
      */
    };
  };
}
