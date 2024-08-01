{ crane, src, protobuf, perl}:

let
  # Common arguments can be set here to avoid repeating them later
  # Note: changes here will rebuild all dependency crates
  commonArgs = {
    inherit src;

    strictDeps = true;

    nativeBuildInputs = [protobuf perl];
    buildInputs = [
    ];
  };

  gurk = crane.buildPackage (commonArgs
    // {
      cargoArtifacts = crane.buildDepsOnly commonArgs;
    });
in
  gurk
