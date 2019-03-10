{stdenv, fetchFromGitHub, cmake, libGLU_combined, zlib, openssl, libyamlcpp, boost
, SDL, SDL_image, SDL_mixer, SDL_gfx }:

let version = "1.0.0.2019.01.25"; in
stdenv.mkDerivation {
  name = "openxcom-extended-${version}";
  src = fetchFromGitHub {
    owner = "MeridianOXC";
    repo = "OpenXcom";
    rev = "a7d1f6e";
    sha256 = "12ms69l3pjq3mp7ffsipsc4kf619l6riiw0cgfjcw1brzfv8xnya";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL SDL_gfx SDL_image SDL_mixer boost libyamlcpp libGLU_combined openssl zlib ];

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
