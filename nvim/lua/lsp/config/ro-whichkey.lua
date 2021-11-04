local wk = require('which-key')

local mappings = {
	q = { ":q<cr>", "Quit"},
	w = { ":w<cr>", "Save"}
}
local opts = {
	prefix = '<leader>'
}

wk.register(mappings,opts)
