{
  config.flake.overlays = {
    buildMozillaMach = (
      self: super: {
        firefox-unwrapped =
          (super.firefox-unwrapped.override {
            enablePGO = false; # It's slow!
            enableLTO = false; # It's slow and take about 45G of RAM
            enableCrashReporter = false; # Remove anal probe
            enableDataReporting = false;
            enableWebRTC = true;
            enableLocation = true;
          }).overrideAttrs
            (_: {
              # Remove anal probes
              MOZ_DATA_REPORTING = "";
              MOZ_TELEMETRY_REPORTING = "";
            });
      }
    );
  };
}
