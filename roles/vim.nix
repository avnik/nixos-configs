{ config, pkgs, ... }:

{
    nixpkgs.overlays = [
        (self: super:  {
            vim = super.vim_configurable.customize {
                vimrcConfig.customRC = ''
                          syntax on
                          filetype on
                          set expandtab
                          set bs=4
                          set tabstop=4
                          set shiftwidth=4
                          set autoindent
                          set smartindent
                          set smartcase
                          set ignorecase
                          set modeline
                          set nocompatible
                          set encoding=utf-8
                          set hlsearch
                          set history=700
                          set t_Co=256
                          set tabpagemax=1000
                          set ruler
                          set nojoinspaces
                          set shiftround

                          " Visual mode pressing * or # searches for the current selection
                          " Super useful! From an idea by Michael Naumann
                          vnoremap <silent> * :call VisualSelection('f')<CR>
                          vnoremap <silent> # :call VisualSelection('b')<CR>
                '';
                vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
                vimrcConfig.vam.pluginDictionaries = [
                  { name = "vim-addon-nix"; }
                  { name = "vim-xkbwitch"; }
                  { name = "vim-signify"; }
                ];
            };
        })
    ];
    environment.systemPackages = with pkgs; [
      vim
    ];
}
