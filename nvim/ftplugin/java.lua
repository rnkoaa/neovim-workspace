-- https://github.com/Nguyen-Hoang-Nam/nvim-dotfiles-kitty/blob/main/lua/lsp/jdtls.lua
--https://github.com/ChrisAmelia/dotfiles/blob/master/nvim/lua/lsp.lua
--
local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local api = vim.api

local root_markers = {"build.gradle", "gradlew", "pom.xml"}
local root_dir = require("jdtls.setup").find_root(root_markers)
local home = os.getenv("HOME")
local workspace_folder = home .. "/.workspace" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local function register_buffer(bufnr, client_id)
  if not clients[bufnr] then
    print("adding client id " .. client_id)
    clients[bufnr] = {client_id}
  else
    print("client id exists")
    table.insert(clients[bufnr], client_id)
  end
end

local opts = {noremap = true, silent = true}

-- mappings
local map = function(type, key, value)
  vim.api.nvim_set_keymap(type, key, value, opts)
  -- api.nvim_buf_set_keymap(bufnr, type, key, value, {noremap = true, silent = true})
end

local function on_attach(client, bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  --vim.notify("Attaching LSP client "..client.id.." to buffer "..bufnr)
  -- register client/buffer relation
  register_buffer(bufnr, client.id)

  print("JDTLS Lsp Attached")
  require("jdtls.setup").add_commands()
  require "lsp-status".register_progress()

  -- mappings
  -- local map = function(type, key, value)
  --   api.nvim_buf_set_keymap(bufnr, type, key, value, {noremap = true, silent = true})
  -- end

  -- TODO: Can we make these look like the saga ones?
  map("n", "gca", '<cmd>lua require("jdtls").code_action()<CR>')
  map("v", "gcb", ':<cmd>lua lua require("jdtls").code_action(true)<CR>')

  -- api.nvim_buf_set_keymap(bufnr, "n", "<leader>o", "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
  -- api.nvim_buf_set_keymap(bufnr, "n", "<leader>a", "<Cmd>lua require'jdtls'.code_action()<CR>", opts)

  -- api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- local opts = {noremap = true, silent = true}

  -- local function buf_set_keymap(mode, mapping, command)
  --   api.nvim_buf_set_keymap(bufnr, mode, mapping, command, opts)
  -- end

  -- api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- buf_set_keymap("n", "<Leader>d", "<Cmd>lua vim.lsp.buf.definition()<CR>")
  -- buf_set_keymap("n", "<Leader>a", [[<Cmd>lua require'jdtls'.code_action()<CR>]])
  -- buf_set_keymap("n", "<Leader><Leader>", "<Cmd>lua vim.lsp.buf.hover()<CR>")
  -- buf_set_keymap("n", "<Leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>")
  -- buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
  -- buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")

  -- buf_set_keymap("n", "gdi", "<Cmd>lua require'jdtls'.organize_imports()<CR>")
  -- buf_set_keymap("n", "gdt", "<Cmd>lua require'jdtls'.test_class()<CR>")
  -- buf_set_keymap("n", "gdn", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>")
  -- buf_set_keymap("v", "gde", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>")
  -- buf_set_keymap("n", "gde", "<Cmd>lua require('jdtls').extract_variable()<CR>")
  -- buf_set_keymap("v", "gdm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>")
end

local config = {
  flags = {
    debounce_text_changes = 150,
    allow_incremental_sync = true,
    server_side_fuzzy_completion = true
  },
  capabilities = {
    workspace = {
      configuration = true
    },
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true
        }
      }
    }
  },
  cmd = {"launch-jdtls.sh", workspace_folder},
  root_dir = require("jdtls.setup").find_root(root_markers)
}

config.on_init = function(client, _)
  client.notify("workspace/didChangeConfiguration", {settings = config.settings})
end

local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

config.init_options = {
  extendedClientCapabilities = extendedClientCapabilities
}

config.settings = {
  -- ['java.format.settings.url'] = home .. '/.config/nvim/language-servers/java-google-formatter.xml',
  -- ['java.format.settings.profile'] = 'GoogleStyle',
  java = {
    signatureHelp = {enabled = true},
    contentProvider = {preferred = "fernflower"},
    completion = {
      favoriteStaticMembers = {}
    },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999
      }
    },
    codeGeneration = {
      generateComments = true
      -- toString = {
      --     template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
      -- },
    },
    configuration = {
      runtimes = {
        {
          name = "JavaSE-17",
          path = home .. "/.sdkman/candidates/java/17.0.1-open"
        },
        {
          name = "JavaSE-11",
          path = home .. "/.sdkman/candidates/java/11.0.12-zulu"
        }
      }
    }
  }
}

config.on_attach = on_attach

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
require("lspconfig")["jdtls"].setup {
  capabilities = capabilities
}

local finders = require "telescope.finders"
local sorters = require "telescope.sorters"
local actions = require "telescope.actions"
local pickers = require "telescope.pickers"
require("jdtls.ui").pick_one_async = function(items, prompt, label_fn, cb)
  local opts = {}
  pickers.new(
    opts,
    {
      prompt_title = prompt,
      finder = finders.new_table {
        results = items,
        entry_maker = function(entry)
          return {
            value = entry,
            display = label_fn(entry),
            ordinal = label_fn(entry)
          }
        end
      },
      sorter = sorters.get_generic_fuzzy_sorter(),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(
          function()
            local selection = actions.get_selected_entry(prompt_bufnr)
            actions.close(prompt_bufnr)

            cb(selection.value)
          end
        )

        return true
      end
    }
  ):find()
end

require("jdtls").start_or_attach(config)

map("n", "gca", "<Cmd>lua require('jdtls').code_action()<CR>", opts)
-- map("v", "gca", "<Cmd>lua require('jdtls').code_action(true)<CR>", opts)
map("n", "gco", "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
map("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "gcr", "<cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
map("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")

map("n", "gdt", "<Cmd>lua require'jdtls'.test_class()<CR>")
map("n", "gdn", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>")
map("v", "gde", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>")
map("n", "gde", "<Cmd>lua require('jdtls').extract_variable()<CR>")
map("v", "gdm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>")
