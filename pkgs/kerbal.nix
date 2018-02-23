{ pkgs, stdenv }:

with pkgs;

let libPath = stdenv.lib.makeLibraryPath [
    stdenv.cc.cc
    mesa
    libpulseaudio
    xlibs.libX11
    xlibs.libXext
    xlibs.libXcursor
    xlibs.libXrandr
    gtk2
    pango
    atk
    glib
    gdk_pixbuf
    cairo
    fontconfig
    freetype
    libpulseaudio
    udev
];
in  
writeShellScriptBin "kerbal" ''
if test -z "$KSP_DIR"; then
  KSP_DIR="$HOME/kerbal_ru"
  if ! test -x "$KSP_DIR/KSP.x86_64"; then
    KSP_DIR="$HOME/kerbal"
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
EXE="KSP"
if "$1" == "--launcher"; then
  EXE="Launcher"
fi
cd $KSP_DIR
exec ${glibc.out}/lib/ld-linux-x86-64.so.2 ./''${EXE}.x86_64 "$@"
''
