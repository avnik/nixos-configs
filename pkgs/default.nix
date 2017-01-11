{ pkgs ? (import <nixpkgs> {}) }:

# let's define our own callPackage to avoid typing all dependencies
let 
callPackage = pkgs.lib.callPackageWith (pkgs // own);
myShellFunc = { name, buildInputs ? [], extraCmds ? ""}: pkgs.myEnvFun {
    inherit name;
    shell = "${pkgs.zsh}/bin/zsh";
    extraCmds = ''
      . ${builtins.getEnv "HOME"}/.zshrc
      ${extraCmds}
    '';
};

own = rec {
    binutils-stuff = pkgs.runCommand "binutils-stuff" { } ''
    #!${pkgs.stdenv.shell}
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    ln -s ${pkgs.binutils.out}/bin/readelf $out/bin
    ln -s ${pkgs.binutils.out}/bin/strings $out/bin
    ln -s ${pkgs.binutils.out}/share/man/man1/readelf.1.gz $out/share/man/man1/
    ln -s ${pkgs.binutils.out}/share/man/man1/strings.1.gz $out/share/man/man1/
    '';
    myShellFun = myShellFunc;
    hammer = (callPackage ./hammer {}).bin;
#    pynstagram = callPackage ./pynstagram {};
};
in
pkgs // {
    inherit own;
}
