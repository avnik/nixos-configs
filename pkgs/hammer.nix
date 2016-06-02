{ pkgs, goPackages ? pkgs.go16Packages }:

let anmitsu-go-shlex = goPackages.buildFromGitHub {
    owner = "anmitsu";
    repo = "go-shlex";
    rev = "53a3d8a";
    sha256 = "0sdlafzkwq4yc4crvw952cgmfzz7y4bi5cm17jsa6dyr5widnyrc";
};
in

goPackages.buildFromGitHub {
   repo = "hammer";
   owner = "asteris-llc";
   version = "1.0.0";
   rev = "c67a27fde1a9476320bad0e884483d32cfd2e52a";
   sha256 = "0fbmh1xgzm0wrkwp5c7w52sijc6b9y3g0b0zw062xsv7b2plcbfq";
   buildInputs = with goPackages; [ cobra context anmitsu-go-shlex logrus viper ];
}

