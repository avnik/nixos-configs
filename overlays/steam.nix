{
  config.flake.overlays = {
    steam = (self: super: {
      steam = super.steam.override {
        extraLibraries = [
          super.pkgs.libSM
          super.pkgs.libpng12
        ];
      };
    });
  };
}
