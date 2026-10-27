{ ... }:
{
  config.vim = {
    lsp.enable = true;
    languages = {
      enableFormat = true;
      enableExtraDiagnostics = false;
      bash.enable = true;
      clang.enable = true;
      cmake.enable = true;
      css.enable = true;
      html.enable = true;
      json.enable = true;
      yaml.enable = true;
      sql.enable = true;
      java.enable = false;
      kotlin.enable = false;
      typescript.enable = true;
      tsx.enable = true;
      scss = {
        enable = true;
        lsp.enable = false;
      };
      go.enable = true;
      haskell = {
        enable = true;
        lsp.enable = false;
      };
      lua.enable = true;
      zig.enable = true;
      python.enable = true;
      rust = {
        enable = true;
        extensions.crates-nvim.enable = true;
      };
      toml.enable = true;
      xml.enable = true;
      tex.enable = true;
      docker.enable = true;
      env.enable = true;
      nix.enable = true;
      markdown.enable = true;
    };
    telescope.enable = true;
    statusline.lualine.enable = true;
    git = {
      enable = true;
      gitsigns.enable = true;
    };
    treesitter.context.enable = true;
    utility.undotree.enable = true;
    filetree.neo-tree.enable = true;
    binds.whichKey.enable = true;
    autocomplete.nvim-cmp.enable = true;
  };
}
