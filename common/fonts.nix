{ config, pkgs, ... }:
{
fonts = {
    enableFontDir = true;
    fontconfig = {
        useEmbeddedBitmaps = true;
        ultimate = {
            enable = true;
        };
    };
#    enableGhostscriptFont = true;
    fonts = with pkgs; [
        dejavu_fonts
        liberation_ttf
        terminus_font
        xorg.fontcronyxcyrillic
        xorg.fontmisccyrillic
        xorg.fontalias
        ubuntu_font_family
        inconsolata
        inconsolata-lgc
        fira-mono
        fira-code
        go-font
        anonymousPro
        corefonts
        vistafonts
        proggyfonts
      ];
};
}
