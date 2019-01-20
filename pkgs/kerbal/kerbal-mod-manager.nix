{ pkgs,  stdenv }:

with pkgs;

let libPath = stdenv.lib.makeLibraryPath [
    gtk2
]; in

let

  HtmlAgilityPack = fetchNuGet {
    baseName = "HtmlAgilityPack";
    version = "1.7.1";
    outputFiles = ["lib/Net45/*"]; # */
    sha256 = "19qicbbpmsvl1k5v98i97c1zh30wv5zwvwrpb1qvf8va4bg34crc";
  };
  SharpCompress = fetchNuGet {
    baseName = "SharpCompress";
    version = "0.10.3";
    sha256 = "1na5ww9n1sfmxfwhbk70nwa32gmk6sh3d1n9akgw57xfk21nb94s";
    outputFiles = ["lib/net40/*"]; # */
  };
in

#(buildDotnetPackage.override { mono=mono58; })  rec {
#  baseName = "kerbal-mod-admin-${version}";
#  version = "2.3.0.7";
#  src = fetchzip {
#    name = "kerbal-mod-admin-src-${version}";
#    url = "https://github.com/MacTee/KSP-Mod-Admin-aOS/archive/${version}.tar.gz";
#    sha256 = "0zwjs5c6g618vr7bp18w8lbrsdirb575p1pbxzn1kahgwvfnrqnk";
#  };
#  xBuildFiles = ["KSPModAdmin_mono.sln"];
#  buildInputs = [ HtmlAgilityPack dotnetPackages.NewtonsoftJson SharpCompress ];
#  FONTCONFIG_FILE = makeFontsConf {
#    fontDirectories = [ freefont_ttf ];
#  };
#}

writeShellScriptBin "kerbal-mod-admin" ''
export LD_LIBRARY_PATH=${libPath}
${mono}/bin/mono ~/kerbal/KSPModAdmin/KSPModAdmin.exe
''
