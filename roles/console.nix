{ config, pkgs, ... }:
{
  imports = [ ./vim.nix ];

  environment.systemPackages = with pkgs; [
    enca # smart codepage recoder with detection
    jq
    yq
    pandoc
    screen
    tmux
    python3Full
    rsync
    psmisc # for killall
    sysstat # for iostat
    tcpdump
    iotop
    htop
    bottom
    bup # for backup tool
    shared-mime-info
    file
    lsof
    zip
    unzip
    unrar
    wget
    p7zip
    xorriso
    libxslt.bin # for xsltproc
    gitAndTools.gitFull
    git-crecord
    git-series
    whois # for whois
    fd # for super-fast `find`
    sd # better sed
    duf
    dua
    dutree
    nix-du # Disk usage reporters
    ripgrep
    inetutils # for telnet
    lm_sensors
    smartmontools
    hdparm
    usbutils
    pciutils
    flashrom # I need it on all local machines (split special local stuff to own role?)
    iana-etc
    picocom
  ];

  programs.bash.interactiveShellInit = ''
    HISTCONTROL=ignoreboth:erasedups
    HISTSIZE=100000                   # big big history
    HISTFILESIZE=100000               # big big history
    shopt -s histappend               # append to history, don't overwrite it

    # Save and reload the history after each command finishes
    PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
  '';
}
