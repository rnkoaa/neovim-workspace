vim.cmd [[ packadd completion-nvim ]]

local lsp = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
local completion = require('completion')

local map = function(mode, key, result)
  vim.api.nvim_buf_set_keymap(0, mode, key, "<cmd>lua "..result.."<cr>", {noremap = true, silent = true})
end

local custom_attach = function(client)
  completion.on_attach()
  print("LSP started.");
  -- Move cursor to the next and previous diagnostic
  map('n', '<leader>dn', 'vim.lsp.diagnostic.goto_next()')
  map('n', '<leader>dp', 'vim.lsp.diagnostic.goto_prev()')
  map('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
  map('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
  map('n','K','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n','gr','<cmd>lua vim.lsp.buf.references()<CR>')
  map('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>')
  map('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
  map('n','gt','<cmd>lua vim.lsp.buf.type_definition()<CR>')
  map('n','<leader>gw','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  map('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
  map('n','<leader>ah','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n','<leader>af','<cmd>lua vim.lsp.buf.code_action()<CR>')
  map('n','<leader>ee','<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>')
  map('n','<leader>ar','<cmd>lua vim.lsp.buf.rename()<CR>')
  map('n','<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  map('n','<leader>ai','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
  map('n','<leader>ao','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
    hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
    hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
    hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false)
  end
end


capabilities.textDocument.completion.completionItem.snippetSupport = true;
-- LSPs
--[[
local servers = { "pyright", "rust_analyzer", "gopls", "tsserver" }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup { 
        capabilities = capabilities;
        on_attach = on_attach;
        -- init_options = {
        --     onlyAnalyzeProjectsWithOpenFiles = true,
        --     suggestFromUnimportedLibraries = false,
        --     closingLabels = true,
        -- };
    }
  end
--]]
lsp.tsserver.setup{
  capabilities = capabilities,
  on_attach = custom_attach
}

lsp.gopls.setup {
  capabilities = capabilities,
  cmd = {"gopls", "serve"},
  settings = {
      gopls = {
      analyses = {
          unusedparams = true,
      },
      staticcheck = true,
      },
  },
}

lsp.pyls.setup{
  capabilities = capabilities,
  on_attach = custom_attach
}

lsp.clangd.setup{on_attach=custom_attach}

-- Lua LSP. NOTE: This replaces the calls where you would have before done `require('nvim_lsp').sumneko_lua.setup()`
--[[
require('nlua.lsp.nvim').setup(require('lspconfig'), {
    capabilities = capabilities;
    on_attach = on_attach;
    init_options = {
        onlyAnalyzeProjectsWithOpenFiles = true,
        suggestFromUnimportedLibraries = false,
        closingLabels = true,
    };
})
--]]

