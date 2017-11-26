{ config, pkgs, ...}:

{
  services.mopidy = {
    enable = true;
    configuration = ''
      [mpd]
      hostname = ::

      [audio]
      output = pulsesink

      [file]
      enabled = true
      media_dirs =
          $XDG_MUSIC_DIR|Music
          ~/|Home
          /mnt/media/music|Common
      show_dotfiles = false
      excluded_file_extensions =
          .jpg
          .jpeg
      follow_symlinks = false
      metadata_timeout = 1000

      [local]
      enabled = true
      library = json
      media_dir = /mnt/media/music
      scan_timeout = 1000
      scan_flush_threshold = 100
      scan_follow_symlinks = false
      excluded_file_extensions =
         .directory
         .html
         .jpeg
         .jpg
         .log
         .nfo
         .png
         .txt
    '';
  };
  environment.systemPackages = with pkgs; [
    gmpc
    ncmpc
    sonata
  ];
}
