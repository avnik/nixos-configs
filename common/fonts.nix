{ config, pkgs, ... }:
{
fonts = {
    fontDir.enable = true;
    fontconfig = {
        useEmbeddedBitmaps = false;
        localConf = ''
          <match target='font'>
            <test name='fontformat' compare='not_eq'>
              <string/>
            </test>
            <test name='family'>
              <string>Fira Code</string>
            </test>
            <edit name='fontfeatures' mode='assign_replace'>
              <string>ss02</string>
              <string>ss03</string>
              <string>ss05</string>
              <string>ss06</string>
              <string>ss08</string>
            </edit>
          </match>
        '';
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
        powerline-symbols
      ];
};
}
