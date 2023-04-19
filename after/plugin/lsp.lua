local lspconfig = require 'lspconfig'
local lsp_signature = require 'lsp_signature'

local border = {
  { "╭", "FloatBoarder" },
  { "─", "FloatBoarder" },
  { "╮", "FloatBoarder" },
  { "│", "FloatBoarder" },
  { "╯", "FloatBoarder" },
  { "─", "FloatBoarder" },
  { "╰", "FloatBoarder" },
  { "│", "FloatBoarder" },
}

local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
  vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
  vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", opts)
  vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
  vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>ls", function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end, opts)
  vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", opts)

  --vim.cmd([[
  --     augroup formatting
  --        autocmd! * <buffer>
  --       autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ bufnr = bufnr })
  --  augroup END
  -- ]])
end

require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')

local servers = {}

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

vim.diagnostic.config {
  virtual_text = false,
  float = {
    border = "rounded"
  },
}

--vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
--  vim.lsp.handlers.signature_help, {
--    border = 'rounded',
--    close_events = { "CursorMoved", "BufHidden", "InsertCharPre" },
--  }
--)
--
--vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
--  vim.lsp.handlers.hover, {
--    border = 'rounded',
--  }
--)

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
    }
  end,
  ['golangci_lint_ls'] = function()
    lspconfig.golangci_lint_ls.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        gopls = {
          gofumpt = true,
        },
      },
      flags = {
        debounce_text_changes = 150,
      },
    }
  end,
  ['gopls'] = function()
    lspconfig.gopls.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        gopls = {
          gofumpt = true,
        },
      },
      flags = {
        debounce_text_changes = 150,
      },
    }
  end,
  ['lua_ls'] = function()
    lspconfig.lua_ls.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
          diagnostics = {
            globals = { "vim" }
          },
        },
      },
    }
  end,
  ['rust_analyzer'] = function()
    lspconfig.rust_analyzer.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      cmd = {
        "rustup", "run", "stable", "rust-analyzer",
      }
    }
  end,
  ['tsserver'] = function()
    lspconfig.tsserver.setup {
      capabilities = capabilities,
      on_attach = on_attach,
    }
  end,
  ['vuels'] = function()
    lspconfig.vuels.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = function(fname)
        local primary = lspconfig.util.find_git_ancestor(fname)
        local fallback = lspconfig.util.root_pattern("package.json", "vue.config.js")
        return primary or fallback
      end,
    }
  end,
}

local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

local sources = {
  formatting.eslint_d.with({
    filetypes = { "svelte", "typescript", "javascript", "vue" }
  }),
  formatting.rustfmt,
  formatting.rustywind,
  formatting.stylua,
  diagnostics.eslint_d.with({
    filetypes = { "svelte", "typescript", "javascript", "vue" }
  }),
  code_actions.eslint_d.with({
    filetypes = { "svelte", "typescript", "javascript", "vue" }
  })
}

null_ls.setup {
  debug = true,
  sources = sources,
  -- on_attach = on_attach
}

require('fidget').setup()
