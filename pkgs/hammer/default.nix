{ pkgs, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hammer-${version}";
  version = "1.0.0";
  goPackagePath = "github.com/asteris-llc/hammer";
  src = fetchFromGitHub {
    repo = "hammer";
    owner = "asteris-llc";
    rev = "c67a27fde1a9476320bad0e884483d32cfd2e52a";
    sha256 = "0fbmh1xgzm0wrkwp5c7w52sijc6b9y3g0b0zw062xsv7b2plcbfq";
  };
  goDeps = ./deps.json;
}

