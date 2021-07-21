{ fetchurl, stdenv, lib, autoPatchelfHook, unzip, strace, pkgs }:

let
  pname = "etxt-antiplagiat-bin";
  version = "unknown";
  name = "etxt-antiplagiat";

in
stdenv.mkDerivation {
  inherit name;
  src = fetchurl {
    url = "https://www.etxt.ru/downloads/cross/ru/linux/etxt_antiplagiat.zip";
    sha256 = "0897c9a814m1wi6wq7pmrqrfm8kwk36cnn7yi0r3fl05q4v5lzvy";
  };
  buildInputs = with pkgs; [
    gcc-unwrapped.lib
    libGL
    libxslt
    qt5.qtbase qt5.qtmultimedia qt5.qtwebkit
    qt5.wrapQtAppsHook
  ];
  nativeBuildInputs = [ autoPatchelfHook unzip ];
  installPhase = ''
    mkdir -p $out/lib $out/bin
    cp EtxtAntiplagiat $out/bin/EtxtAntiplagiat
    cat <<EOT >$out/bin/Etxt
#/bin/sh -x
exec ${strace}/bin/strace -e trace=open ${placeholder "out"}/bin/EtxtAntiplagiat    
  '';
  meta = with lib; {
    platforms = [ "i686-linux" ];
    maintainers = with maintainers; [ avnik ];
  };
}

