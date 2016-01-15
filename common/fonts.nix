{ config, pkgs, ... }:
{
fonts = {
    enableFontDir = true;
    fontconfig = {
        ultimate = {
            enable = true;
            useEmbeddedBitmaps = true;
            renderMonoTTFAsBitmap = true;
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
        corefonts
        vistafonts
        proggyfonts
      ];
};
}
