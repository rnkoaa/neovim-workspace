local cmd = vim.cmd
local g = vim.g
local fn = vim.fn
local execute = vim.api.nvim_command

g.mapleader = ' '

require('settings')

require('keymappings')

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

vim.cmd [[packadd packer.nvim]]
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

-- import packer plugins
require('plugins')

require('lsp_config')

require('config.compe_config')
require('config.treesitter')
require('config.colorschemes')
require('config.fugitive')

