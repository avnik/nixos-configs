{ config, pkgs, ... }:
{
fonts = {
    enableFontDir = true;
    fontconfig = {
        useEmbeddedBitmaps = true;
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
        go-font
        corefonts
        vistafonts
        noto-fonts
        noto-fonts-extra
        droid-fonts
      ];
};
}
