{ config, pkgs, ... }:
let myTexlive = with pkgs; texlive.combine {
  inherit (texlive) scheme-small pdfjam 
                    collection-langcyrillic
                    collection-langenglish
                    collection-langeuropean
                    collection-latexextra
                    collection-mathscience
                    collection-fontsextra
                    cm-super;
}; in
{
    environment.systemPackages = with pkgs; [
      myTexlive
      pdftk
    ];
}
