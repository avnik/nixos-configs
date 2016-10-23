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
    myShellFun = myShellFunc;
    hammer = (callPackage ./hammer {}).bin;
#    pynstagram = callPackage ./pynstagram {};
};
in
pkgs // {
    inherit own;
}
