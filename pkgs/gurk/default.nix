{
  crane,
  lib,
  src,
  pkg-config,
  protobuf,
  openssl,
  sqlx-cli,
  writableTmpDirAsHomeHook,
}:

let
  unfilteredRoot = src;
  # Common arguments can be set here to avoid repeating them later
  # Note: changes here will rebuild all dependency crates
  commonArgs = {
    src = lib.sources.cleanSourceWith {
      src = unfilteredRoot;
      filter = path: type:
        let
          rel = lib.removePrefix "${unfilteredRoot}/" (toString path);
        in
          lib.hasSuffix "Cargo.toml" rel
          || lib.hasPrefix "Cargo.lock" rel
          || lib.hasPrefix "src/" rel
          || lib.hasPrefix "migrations/" rel
          || lib.hasPrefix "xtask/" rel
          || lib.hasPrefix "benches/" rel
          || lib.hasPrefix ".sqlx/" rel;
    }; 
    strictDeps = true;

    nativeBuildInputs = [
      protobuf
      pkg-config
      writableTmpDirAsHomeHook
      sqlx-cli
    ];
    buildInputs = [
      openssl
    ];
    # Use system OpenSSL instead of vendoring it.
    # libsqlite3-sys still bundles SQLCipher with its own OpenSSL via
    # the bundled-sqlcipher-vendored-openssl cargo feature.
    OPENSSL_NO_VENDOR = "1";
    PROTOC = "${protobuf}/bin/protoc";

    # Fix following error
    # xtasks behave weird with crane
    postPatch = ''
      substituteInPlace Cargo.toml --replace-fail '"xtask"' ' '
    '';
    cargoExtraArgs = "--offline";
#    preBuild = ''
#      export DATABASE_URL=sqlite:./db.sqlite3
#      sqlx database create
#      sqlx migrate run
#    '';
  };

  gurk = crane.buildPackage (
    commonArgs
    // {
      cargoArtifacts = null; # crane.buildDepsOnly commonArgs;
#      postUnpack = ''
#        substituteInPlace $sourceRoot/src/storage/sql/storage.rs --replace-fail Future std::future::Future
#      '';
      doCheck = false;
    }
  );
in
gurk
