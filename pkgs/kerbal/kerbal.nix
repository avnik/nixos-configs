{
  pkgs,
  stdenv,
  lib,
}:

with pkgs;

let
  libPath = lib.makeLibraryPath [
    stdenv.cc.cc
    libglvnd
    libGL
    libGLU
    mesa
    libpulseaudio
    libx11
    libxext
    libxcursor
    libxrandr
    gtk2
    pango
    atk
    glib
    gdk-pixbuf
    cairo
    fontconfig
    freetype
    libpulseaudio
    udev
    zlib
  ];
in
writeShellScriptBin "kerbal" ''
  if test -z "$KSP_DIR"; then
    KSP_DIR="$HOME/kerbal_ru"
    if ! test -x "$KSP_DIR/KSP.x86_64"; then
      KSP_DIR="$HOME/kerbal/game"
      if ! test -x "$KSP_DIR/KSP.x86_64"; then
         echo "Can't find Kerbal!"
         exit 1
      fi
    fi
  else
    if ! test -x "$KSP_DIR/KSP.x86_64"; then
         echo "Can't find Kerbal!"
         exit 1
    fi
  fi
  export LD_LIBRARY_PATH=${libPath}
  #:/run/opengl-drivers/lib
  export LC_ALL=C
  export LD_PRELOAD="${glibc.out}/lib/libpthread.so.0 ${libglvnd}/lib/libGL.so.1"
  EXE="KSP"
  if test "$1" == "--launcher"; then
    EXE="Launcher"
  fi
  cd $KSP_DIR
  exec ${glibc.out}/lib/ld-linux-x86-64.so.2 ./''${EXE}.x86_64 "$@"
''
