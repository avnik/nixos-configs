{ lib, pkgs, config, inputs, ... }:
{
    programs.doom-emacs = {
      enable = true;
#      emacsPackage = pkgs.emacsUnstable; 
      emacsPackagesOverlay = self: super: { 
        sln-mode = pkgs.runCommand "sln-mode-stub" {} "";
        irony = super.irony.overrideAttrs (old: {
          cmakeFlags = old.cmakeFlags or [ ] ++ [ 
            "-DCMAKE_INSTALL_BINDIR=bin"
            "-DLIBCLANG_LIBRARY=${pkgs.llvmPackages.libclang.lib}/lib/libclang.so"
            "-DLIBCLANG_INCLUDE_DIR=${pkgs.llvmPackages.libclang.dev}/include"
          ];
          NIX_CFLAGS_COMPILE = "-UCLANG_RESOURCE_DIR";
          preConfigure = ''
            cd server
          '';
          preBuild = ''
            make
            install -D bin/irony-server $out/bin/irony-server
            cd ..
          '';
          checkPhase = ''
            cd source/server
            make check
            cd ../..
          '';
          preFixup = ''
            rm -rf $out/share/emacs/site-lisp/elpa/*/server
          '';
          dontUseCmakeBuildDir = true;
          doCheck = true;
          packageRequires = [ self.emacs ];
          nativeBuildInputs = [ pkgs.cmake pkgs.llvmPackages.llvm pkgs.llvmPackages.clang ];
        });
      };
      doomPrivateDir = ./doom.d;
    };
}
