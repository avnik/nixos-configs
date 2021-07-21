{ lib, stdenv, fetchFromGitHub, cmake, libGL, libGLU, zlib, openssl, libyamlcpp, boost
, SDL, SDL_image, SDL_mixer, SDL_gfx, pkgconfig }:

let version = "1.0.0.2020.04.05"; in
stdenv.mkDerivation {
  name = "openxcom-extended-${version}";
  src = fetchFromGitHub {
    owner = "MeridianOXC";
    repo = "OpenXcom";
    rev = "43e7d36";
    sha256 = "1mdgls1g9g327cxnih1m935lhc637wmb9707596rcqvk9pqpvd5k";
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
    maintainers = [ lib.maintainers.cpages ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
  };

}
