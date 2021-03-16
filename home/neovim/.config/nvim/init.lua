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

require('config')

-------------------- OPTIONS -------------------------------
-- local indent = 2
-- opt('b', 'expandtab', true)                           -- Use spaces instead of tabs
-- opt('b', 'shiftwidth', indent)                        -- Size of an indent
-- opt('b', 'smartindent', true)                         -- Insert indents automatically
-- opt('b', 'tabstop', indent)                           -- Number of spaces tabs count for
-- opt('o', 'completeopt', 'menuone,noinsert,noselect')  -- Completion options (for deoplete)
-- opt('o', 'hidden', true)                              -- Enable modified buffers in background
-- opt('o', 'ignorecase', true)                          -- Ignore case
-- opt('o', 'joinspaces', false)                         -- No double spaces with join after a dot
-- opt('o', 'scrolloff', 4 )                             -- Lines of context
-- opt('o', 'shiftround', true)                          -- Round indent
-- opt('o', 'sidescrolloff', 8 )                         -- Columns of context
-- opt('o', 'smartcase', true)                           -- Don't ignore case with capitals
-- opt('o', 'splitbelow', true)                          -- Put new windows below current
-- opt('o', 'splitright', true)                          -- Put new windows right of current
-- opt('o', 'termguicolors', true)                       -- True color support
-- opt('o', 'wildmode', 'list:longest')                  -- Command-line completion mode
-- opt('w', 'list', true)                                -- Show some invisible characters (tabs...)
-- opt('w', 'number', true)                              -- Print line number
-- opt('w', 'relativenumber', true)                      -- Relative line numbers
-- opt('w', 'wrap', false)    


