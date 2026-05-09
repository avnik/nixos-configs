{
  config.flake.overlays = {
    deno = (
      self: super: {
        deno = super.deno.overrideAttrs (oa: {
          # Checks require over 70Gb of build space in tmpfs
          doCheck = false;

          # If we rebuild it, do it blazing fast (no LTO)
          postPatch = (oa.postPatch or "") + ''
            tomlq -ti '.profile.release.lto = false' Cargo.toml
          '';
        });
      }
    );
  };
}
