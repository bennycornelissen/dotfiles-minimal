require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = {
    "bash",
    "c",
    "dockerfile",
    "git_config",
    "gitattributes",
    "gitignore",
    "go",
    "hcl",
    "html",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "ruby",
    "rust",
    "sql",
    "terraform",
    "typescript",
    "vim",
    "xml",
    "yaml"
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
}
