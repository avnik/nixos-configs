{ config, pkgs, ... }:

let configF = pkgs.runCommand "system.pa" {} ''
   cat ${config.hardware.pulseaudio.package.daemon}/etc/pulse/system.pa \
     | sed '/module-native-protocol-unix/ s/$/ auth-group=pulse auth-group-enable=1 auth-anonymous=1/' \
     > $out
'';
in

{
  nixpkgs.config.firefox = {
    enableAdobeFlash = true;
  };

  hardware = {
      opengl = {
          driSupport32Bit = true;
      };

      pulseaudio = {
          enable = true;
          systemWide = true;
          configFile = configF;
      };
  };

  services.openssh.forwardX11 = true;

  environment.systemPackages = with pkgs; [
    alock
    chromium
    firefox
    gimp-with-plugins
    libreoffice
    maim sxiv
    pavucontrol
    qastools
    aumix
    mpv mplayer mpg123 youtube-dl
    mp3splt mp3splt-gtk
    dex desktop_file_utils
    xsel
    ## windowmanagers, which I want to be built by default
    fvwm awesome qtile
    zathura ## for pdfs
    #apvlv ## for pdfs
  ];

  # I use systemwide pulse on my desktops, so won't have him go away on upgrades
  systemd.services.pulseaudio.restartIfChanged = false;
}
