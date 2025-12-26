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
    packages = with pkgs; [
      dejavu_fonts
      liberation_ttf
      terminus_font
      ubuntu-classic
      inconsolata
      inconsolata-lgc
      go-font
      corefonts
      vista-fonts
      noto-fonts
      droid-fonts
      powerline-fonts
      font-awesome
      fira-code
      victor-mono
    ];
  };
}
