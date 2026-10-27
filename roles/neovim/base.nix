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
      joinspaces = false;
      shiftround = true;
      backspace = "eol,indent,start";
      langmap = "ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>";
    };
    luaConfigPost = ''
      vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "#000000" })
    '';
    mini.align.enable = true;
    languages = {
      enableTreesitter = true;
      nix.enable = true;
      markdown.enable = true;
    };
  };
}
