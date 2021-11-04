local use = require("packer").use
require("packer").startup(
  function()
    -- For Packer
    use "wbthomason/packer.nvim"

    -- Explorer

    use {
      "kyazdani42/nvim-tree.lua",
      requires = "kyazdani42/nvim-web-devicons"
      -- config = function()
      --   require "nvim-tree".setup {}
      -- end
    }

    use {
      "folke/which-key.nvim"
    }

    use "mhartington/formatter.nvim"
    use "neovim/nvim-lspconfig"
    use "glepnir/lspsaga.nvim"
    use "onsails/lspkind-nvim"

    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-buffer"
    use "EdenEast/nightfox.nvim"
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-path"
    use "saadparwaiz1/cmp_luasnip"
    use "L3MON4D3/LuaSnip" -- Snippets plugin
    use "windwp/nvim-autopairs"
    use "maxmellon/vim-jsx-pretty"
    -- Highlight, edit, and navigate code using a fast incremental parsing library
    use "nvim-treesitter/nvim-treesitter"
    use "nvim-lualine/lualine.nvim"
    -- Additional textobjects for treesitter
    use "nvim-treesitter/nvim-treesitter-textobjects"
    use "tpope/vim-commentary" -- "gc" to comment visual regions/lines
    -- Add indentation guides even on blank lines
    use "lukas-reineke/indent-blankline.nvim"
    use {
      "nvim-telescope/telescope.nvim",
      requires = {{"nvim-lua/plenary.nvim"}}
    }
    use "mfussenegger/nvim-jdtls"
  end
)
