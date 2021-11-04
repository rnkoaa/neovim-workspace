local utils = require('settings.utils')

require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false
      }
    }
  }
}

--Add leader shortcuts
utils.map("n", "<C-p>", "<Cmd>lua require('telescope.builtin').find_files()<cr>")
-- utils.map("n", "<leader>tf", [[<cmd>lua require('telescope.builtin').find_files()<cr>]], opts)
-- utils.map("n", "<C-p>", [[<cmd>lua require('telescope.builtin').find_files()<cr>]], opts)
-- utils.map("n", "<leader>fg", [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], opts)
-- utils.map("n", "<leader>fb", [[<cmd>lua require('telescope.builtin').buffers()<cr>]], opts)
-- utils.map("n", "<leader>fh", [[<cmd>lua require('telescope.builtin').help_tags()<cr>]], opts)

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm"
    }
  },
  indent = {
    enable = true
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner"
      }
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer"
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer"
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer"
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer"
      }
    }
  }
}

