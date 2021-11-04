local utils = require("settings.utils")
-- Install packer
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

vim.api.nvim_exec(
  [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]],
  false
)

require('plugins')

require("nvim-autopairs").setup()
require("lspkind").init()

require("nightfox").load("nordfox")

require("lualine").setup(
  {
    theme = "nightfox"
  }
)

--Incremental live completion (note: this is now a default on master)
vim.o.inccommand = "nosplit"

--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default
vim.wo.number = true

--Do not save when switching buffers (note: this is now a default on master)
vim.o.hidden = true

--Enable mouse mode
vim.o.mouse = "a"

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

--Set colorscheme (order is important here)
vim.o.termguicolors = true
-- vim.g.onedark_terminal_italics = 2

--Set statusbar
-- vim.g.lightline = {
--   colorscheme = 'onedark',
--   active = { left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified' } } },
--   component_function = { gitbranch = 'fugitive#head' },
-- }

--Remap space as leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", {noremap = true, silent = true})
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Remap for dealing with word wrap
local opts = {noremap = true, expr = true, silent = true}
vim.api.nvim_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", opts)
vim.api.nvim_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", opts)

-- vim.api.nvim_set_keymap('i', 'jk', "<ESC>", opts)
-- vim.api.nvim_set_keymap('i', 'kj', "<ESC>", opts)

-- Highlight on yank
vim.api.nvim_exec(
  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
  false
)

-- Y yank until the end of line  (note: this is now a default on master)
vim.api.nvim_set_keymap("n", "Y", "y$", {noremap = true})

--Map blankline
vim.g.indent_blankline_char = "┊"
vim.g.indent_blankline_filetype_exclude = {"help", "packer"}
vim.g.indent_blankline_buftype_exclude = {"terminal", "nofile"}
vim.g.indent_blankline_char_highlight = "LineNr"
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- Telescope
require('lsp')
-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

require("lsp.config.ro-nvimcmp")
-- require("nvim-autopairs.completion.cmp").setup {
--   map_cr = true,
--   map_complete = true,
--   auto_select = true
-- }

require("lsp.config.ro-telescope")
require("lsp.languages.ro-tsserver")
require("keymappings")
require("lsp.config.ro-keybindings")
require("lsp.config.ro-formatter")
require("lsp.config.ro-nvimtree")
require("lsp.config.ro-whichkey")

