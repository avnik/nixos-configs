{ config, pkgs, ... }:
{
fonts = {
    fontDir.enable = true;
    fontconfig = {
        useEmbeddedBitmaps = true;
    };
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
