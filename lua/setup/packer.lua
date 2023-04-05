-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  -- LSP Configuration
  use {
    'neovim/nvim-lspconfig',
    opts = {
      format = { timeout_ms = 5000 }
    },
    requires = {
      -- Automatically installs LSPs
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Status Updates
      'j-hui/fidget.nvim',

      -- Additional Goodies
      'folke/neodev.nvim',
    },
  }

  -- Autocompletion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      {
        'L3MON4D3/LuaSnip',
        wants = { "friendly-snippets", "vim-snippets" },
      },
      "rafamadriz/friendly-snippets",
      "honza/vim-snippets",
      "ray-x/lsp_signature.nvim",
    },
  }

  use {
    'NvChad/nvim-colorizer.lua', -- Preview colors
    config = function()
      require('colorizer').setup {
        filetypes = { '*', '!packer' },
        user_default_options = {
          tailwind = 'lsp',
          names = false,
          sass = { enable = true, parsers = { css = true } },
        },
      }
    end,
  }

  use {
    'axelvc/template-string.nvim',
    config = function()
      require('template-string').setup {
        filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue', 'svelte' },
        remove_template_string = true,
        restore_quotes = {
          normal = [[']],
          jsx = [["]],
        },
      }
    end,
    event = 'InsertEnter',
    ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue', 'svelte' },
  }

  use {
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  }

  use('windwp/nvim-autopairs')

  use('folke/zen-mode.nvim')

  -- install without yarn or npm
  use {
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  }

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    -- or                            , branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
    cond = vim.fn.executable 'make' == 1
    ,
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use { 'kyazdani42/nvim-web-devicons', opt = true }

  use {
    'akinsho/bufferline.nvim', tag = 'v3.*',
    requires = { 'kyazdani42/nvim-web-devicons' },
  }

  use('tpope/vim-fugitive')

  -- Treesitter
  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

  -- Prime
  use('theprimeagen/harpoon')

  -- Theme and colors
  use { "catppuccin/nvim", as = "catppuccin" }

  -- Auto close and rename tags
  use {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  }

  -- Change surround
  use {
    "tpope/vim-surround",
    setup = function()
      vim.o.timeoutlen = 500
    end,
  }

  use { "tpope/vim-repeat" }

  -- Change command line and notifications
  use {
    "folke/noice.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  }

  -- AI Overlords
  use {
    "jackMort/ChatGPT.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  }

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})
