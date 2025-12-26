{ lib
, stdenv
, fetchurl
, autoreconfHook
, pkg-config
, libmp3splt
, wrapGAppsHook3
, libaudclient
, dbus-glib
, gtk3
, which
, gst_all_1
}:

stdenv.mkDerivation rec {
  pname = "mp3splt-gtk";
  version = "0.9.2";

  src = fetchurl {
    url = "mirror://sourceforge/mp3splt/${pname}-${version}.tar.gz";
    sha256 = "0l3ni1iwf95lrr0w7zadqz5pcy5kbk8432l4fkzsc6jx5facr110";
  };

  configureFlags = [ "--disable-gnome" ];
  hardeningDisable = [ "format" ];
  CFLAGS = "-fcommon";

  nativeBuildInputs = [ autoreconfHook pkg-config which wrapGAppsHook3 ];
  buildInputs = [ libaudclient dbus-glib gtk3 libmp3splt ] ++
    (with gst_all_1; [ gstreamer.dev gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly ]);

  meta = with lib; {
    description = "Graphical utility to split mp3, ogg vorbis and FLAC files without decoding";
    homepage = https://sourceforge.net/projects/mp3splt/;
    license = licenses.gpl2;
    maintainers = [ maintainers.avnik ];
    platforms = platforms.unix;
  };
}
