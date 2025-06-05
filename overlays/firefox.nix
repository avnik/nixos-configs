{
  config.flake.overlays = {
    buildMozillaMach = (self: super: {
      firefox-unwrapped = (super.firefox-unwrapped.override {
        pgoSupport = false; # It's slow!
        ltoSupport = false; # It's slow and take about 45G of RAM
        crashreporterSupport = false; # Remove anal probe
        privacySupport = true;
        webrtcSupport = true;
        geolocationSupport = true;
      }).overrideAttrs (_: {
        # Remove anal probes
        MOZ_DATA_REPORTING = "";
        MOZ_TELEMETRY_REPORTING = "";
      });
    });
  };
}
