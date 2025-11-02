{ src
, lib
, stdenv
, fetchFromGitHub
, cmake
, libGL
, libGLU
, zlib
, openssl
, yaml-cpp
, boost
, SDL
, SDL_image
, SDL_mixer
, SDL_gfx
, pkg-config
}:

let version = "git-via-flake"; in
stdenv.mkDerivation {
  name = "openxcom-extended-${version}";
  inherit src;

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ SDL SDL_gfx SDL_image SDL_mixer boost yaml-cpp libGL libGLU openssl zlib ];

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
