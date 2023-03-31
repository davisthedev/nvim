local lspconfig = require 'lspconfig'

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
  vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
  vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
  vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end, opts)
  vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", opts)

  vim.cmd([[
        augroup formatting
            autocmd! * <buffer>
            autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ bufnr = bufnr })
        augroup END
    ]])
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
  float = {
    border = "rounded"
  },
}

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      handlers = handlers
    }
  end,
  ['golangci_lint_ls'] = function()
    lspconfig.golangci_lint_ls.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      handlers = handlers,
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
      handlers = handlers,
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
      handlers = handlers,
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    }
  end,
  ['rust_analyzer'] = function()
    lspconfig.rust_analyzer.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      handlers = handlers,
      cmd = {
        "rustup", "run", "stable", "rust-analyzer",
      }
    }
  end,
  ['tsserver'] = function()
    lspconfig.tsserver.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      handlers = handlers,
    }
  end,
  ['vuels'] = function()
    lspconfig.vuels.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      handlers = handlers,
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

local sources = {
  formatting.prettierd.with({
    filetypes = { "svelte", "typescript", "javascript", "vue" }
  }),
  formatting.stylua,
  diagnostics.eslint_d.with({
    filetypes = { "svelte", "typescript", "javascript", "vue" }
  })
}

null_ls.setup {
  debug = true,
  sources = sources,
  -- on_attach = on_attach
}

require('fidget').setup()
