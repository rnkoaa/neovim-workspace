-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
 -- Packer can manage itself as an optional plugin
  use {'wbthomason/packer.nvim', opt = true}

  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/completion-nvim'
  use 'anott03/nvim-lspinstall'

  use {"hrsh7th/nvim-compe"}

  use {"nvim-treesitter/nvim-treesitter"}
  use {'nvim-treesitter/playground' }

  use {"chriskempson/base16-vim"}

    -- Fuzzy finder
  use {
      'nvim-telescope/telescope.nvim',
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }
  use 'jremmen/vim-ripgrep'

    -- Vim dispatch
  use { 'tpope/vim-dispatch' }

  -- Fugitive for Git
  use { 'tpope/vim-fugitive' }
  use { 'tpope/vim-surround' }
  use { 'tpope/vim-commentary' }

end
)
