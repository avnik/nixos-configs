{ self
, deploy-rs
, flake-utils
, nixpkgs
, nixpkgs-stable
, sops-nix
, ...
}@inputs:
(flake-utils.lib.eachDefaultSystem (system:
  let
    inherit (nixpkgs.lib) mapAttrs attrValues;
    pkgs = import nixpkgs { inherit system; };
    joinDrvs = pkgs.callPackage ./join-drvs.nix { };
  in
  {
    defaultApp = self.apps.${system}.deploy;
    defaultPackage = self.packages.${system}.hosts;

    overlays = [
      (final: prev: {
          stable = nixpkgs-stable.legacyPackages.${system};
       })
    ];

    apps = {
      deploy = {
        type = "app";
        program = "${deploy-rs.packages."${system}".deploy-rs}/bin/deploy";
      };
    };

    packages = {
      hosts = joinDrvs "hosts" (mapAttrs (_: v: v.profiles.system.path) self.deploy.nodes);
      images = joinDrvs "images" self.images;
      bootx64 = let
        grubPkgs = pkgs;
        targetArch =
          if pkgs.stdenv.isi686 /*|| config.boot.loader.grub.forcei686 */then
            "ia32"
          else if pkgs.stdenv.isx86_64 then
            "x64"
          else if pkgs.stdenv.isAarch32 then
            "arm"
          else if pkgs.stdenv.isAarch64 then
            "aa64"
          else
            throw "Unsupported architecture";

        in pkgs.runCommand "grub-standalone" { } ''
          mkdir -p $out/EFI/boot
          echo 'configfile ''${cmdpath}/grub.cfg' >$out/EFI/boot/embedded.cfg
          ${grubPkgs.grub2_efi}/bin/grub-mkstandalone \
            --directory=${grubPkgs.grub2_efi}/lib/grub/${grubPkgs.grub2_efi.grubTarget} \
            -o $out/EFI/boot/boot${targetArch}.efi  \
            --themes="" \
            -O ${grubPkgs.grub2_efi.grubTarget} \
            "boot/grub/grub.cfg=$out/EFI/boot/embedded.cfg" -v
      '';
    };

    devShell = pkgs.callPackage ./shell.nix {
      inherit (sops-nix.packages.${system}) sops-pgp-hook;
      inherit (deploy-rs.packages.${system}) deploy-rs;
    };
  })
)
// (import ./deploy.nix inputs)
// (import ./images.nix inputs)
