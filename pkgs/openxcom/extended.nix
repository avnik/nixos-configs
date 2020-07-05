{stdenv, fetchFromGitHub, cmake, libGL, libGLU, zlib, openssl, libyamlcpp, boost
, SDL, SDL_image, SDL_mixer, SDL_gfx, pkgconfig }:

let version = "1.0.0.2020.04.05"; in
stdenv.mkDerivation {
  name = "openxcom-extended-${version}";
  src = fetchFromGitHub {
    owner = "MeridianOXC";
    repo = "OpenXcom";
    rev = "41873c291";
    sha256 = "1864ymdz1sk6q8agd1a0170xbhz1yxha5ln8q69b380viyf7vhl5";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ SDL SDL_gfx SDL_image SDL_mixer boost libyamlcpp libGL libGLU openssl zlib ];

  postInstall = ''
    mv $out/bin/openxcom $out/bin/openxcom-extended
  '';

  meta = {
    description = "Open source clone of UFO: Enemy Unknown (extended edition)";
    homepage = https://openxcom.org;
    repositories.git = https://github.com/SupSuper/OpenXcom.git;
    maintainers = [ stdenv.lib.maintainers.cpages ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3;
  };

}
