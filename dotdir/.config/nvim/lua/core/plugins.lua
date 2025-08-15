local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  'wbthomason/packer.nvim',
  'ellisonleao/gruvbox.nvim',
  {
    'dracula/vim',
    lazy = false,
  },
  'nvim-tree/nvim-tree.lua',
  'nvim-tree/nvim-web-devicons',
  'nvim-lualine/lualine.nvim',
  {
    'nvim-treesitter/nvim-treesitter',
    version = "0.9.2",
  },
  'bluz71/vim-nightfly-colors',
  'vim-test/vim-test',
  'lewis6991/gitsigns.nvim',
  -- 'preservim/vimux',
  -- 'christoomey/vim-tmux-navigator',
  'tpope/vim-fugitive',
  -- completion
  'hrsh7th/nvim-cmp',
  "williamboman/mason.nvim",
  'hrsh7th/cmp-nvim-lsp',
  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip',
  "rafamadriz/friendly-snippets",
  "github/copilot.vim",
  "neovim/nvim-lspconfig",
  "williamboman/mason-lspconfig.nvim",
  "glepnir/lspsaga.nvim",
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "gbprod/none-ls-shellcheck.nvim",
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
  },
  -- { "z0mbix/vim-shfmt", ft = "sh" }, -- It's just shfmt
  {
	  'nvim-telescope/telescope.nvim',
	  tag = '0.1.4',
	  dependencies = { {'nvim-lua/plenary.nvim'} }
  },
  "s1n7ax/nvim-terminal",
  "ojroques/nvim-bufdel",
  "ray-x/go.nvim",
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {}
  },
  {
    "kaplanz/retrail.nvim",
    opts = {}, -- calls `setup` using provided `opts`
  },
  {
    "ellisonleao/carbon-now.nvim",
    lazy = true,
    cmd = "CarbonNow",
    ---@param opts cn.ConfigSchema
    opts = {}
  },
  dependencies = {  -- optional packages
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  }
}

local opts = {}

require("lazy").setup(plugins, opts)
