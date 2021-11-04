local utils = require("settings/utils")
-- explorer
utils.map('n', '<Leader>e', ':NvimTreeToggle<CR>', {noremap = true, silent = true})
utils.map('n', '-', ':RnvimrToggle<CR>', {noremap = true, silent = true})

-- better window movement
utils.map('n', '<C-h>', '<C-w>h', {silent = true})
utils.map('n', '<C-j>', '<C-w>j', {silent = true})
utils.map('n', '<C-k>', '<C-w>k', {silent = true})
utils.map('n', '<C-l>', '<C-w>l', {silent = true})

-- escape from insert mode
utils.map("i", "jk", "<ESC>")
utils.map("i", "kj", "<ESC>")
utils.map("i", "jj", "<ESC>")

utils.map("n", "<leader>p", '"_dp')

-- Y yank until the end of line
utils.map("n", "Y", "y$")
-- map('n', '<leader>/', '<cmd>noh<CR>') -- Clear highlights
utils.map("n", "<A-/>", "<cmd>noh<CR>") -- Clear highlights
utils.map("i", "jk", "<Esc>")
utils.map("", "<leader>c", '"+y') --Copy to clipboard in normal, visual, select and operator modes
utils.map("i", "<C-u>", "<C-g>u<C-u>") -- Make <C-u> undo-friendly
utils.map("i", "<C-w>", "<C-g>u<C-w>") -- Make <C-w> undo-friendly
