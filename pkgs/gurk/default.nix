{ crane, src, protobuf, perl }:

let
  # Common arguments can be set here to avoid repeating them later
  # Note: changes here will rebuild all dependency crates
  commonArgs = {
    inherit src;

    strictDeps = true;

    nativeBuildInputs = [ protobuf perl ];
    buildInputs = [
    ];
    # Fix following error
    #  > error: failed to parse manifest at `/build/source/Cargo.toml`
    #  >
    #  > Caused by:
    #   >   feature `edition2024` is required
    #  sed -i -e '1icargo-features = [ "edition2024" ]' Cargo.toml
  };

  gurk = crane.buildPackage (commonArgs
    // {
    cargoArtifacts = crane.buildDepsOnly commonArgs;
    postUnpack = ''
      substituteInPlace $sourceRoot/src/storage/sql/storage.rs --replace-fail Future std::future::Future
    '';
    doCheck = false;
  });
in
gurk
