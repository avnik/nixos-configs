{
  config.flake.overlays = {
    tla = (self: super: {
      tla = super.tla.override { stdenv = super.gcc13Stdenv; };
    });
  };
}
