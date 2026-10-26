{ ... }:
{
  config.vim = {
    viAlias = true;
    vimAlias = true;
    searchCase = "smart";
    options = {
      expandtab = true;
      tabstop = 4;
      shiftwidth = 4;
      autoindent = true;
      smartindent = true;
      modeline = true;
      encoding = "utf-8";
      fileformats = "unix,dos,mac";
      hlsearch = true;
      history = 700;
      ruler = true;
      nojoinspaces = true;
      shiftround = true;
      backspace = "eol,indent,start";
      langmap = "ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>";
    };
    mini.align.enable = true;
    languages = {
      enableTreesitter = true;
      nix.enable = true;
      markdown.enable = true;
    };
  };
}
