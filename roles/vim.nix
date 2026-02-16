{ config, pkgs, ... }:

{
  nixpkgs.config.vim.ftNix = false;

  nixpkgs.overlays = [
    (self: super: {
      configuredVim = super.vim-full.customize {
        name = "vim";
        vimrcConfig.customRC = ''
          syntax on
          filetype on
          set expandtab
          set tabstop=4
          set shiftwidth=4
          set autoindent
          set smartindent
          set smartcase
          set ignorecase
          set modeline
          set nocompatible
          set encoding=utf-8
          set ffs=unix,dos,mac 
          set hlsearch
          set history=700
          set t_Co=256
          set tabpagemax=1000
          set ruler
          set nojoinspaces
          set shiftround
          set backspace="eol,indent,start"
          set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>                                                                              
          " Visual mode pressing * or # searches for the current selection
          " Super useful! From an idea by Michael Naumann
          vnoremap <silent> * :call VisualSelection('f')<CR>
          vnoremap <silent> # :call VisualSelection('b')<CR>
        '';
        vimrcConfig.packages.default = with pkgs.vimPlugins; {
          start = [
            vim-addon-nix
            ctrlp-vim
            vim-easy-align
            haskell-vim
            quickfixstatus
            rainbow_parentheses-vim
            syntastic
            vim-autoformat
            vim-go
            vim-signify
            undotree
          ];
        };
      };
      configuredVi = super.runCommand "configured-vi" { } ''
        #!${super.stdenv.shell}
        mkdir -p $out/bin
        ln -s ${self.configuredVim.out}/bin/vim $out/bin
      '';
    })
  ];
  environment.systemPackages = with pkgs; [
    configuredVim
  ];
}
