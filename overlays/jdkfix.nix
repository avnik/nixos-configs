{
  config.flake.overlays.jdkfix = (final: prev: {
    jdk8 = prev.jdk8.overrideAttrs {
      separateDebugInfo = false;
      __structuredAttrs = false;
    };
  }
  );
}
