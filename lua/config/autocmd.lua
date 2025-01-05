vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('trim-trailing-whitespace', { clear = true }),
  pattern = '*',
  -- command = [[%s/\s\+$//e]],
  callback = function()
    if vim.bo.modifiable and not vim.bo.readonly then
      vim.cmd([[%s/\s\+$//e]])
    end
  end
})

vim.api.nvim_create_autocmd({ "BufWritePre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup('set-fileformat-unix', { clear = true }),
  pattern = "*",
  -- command = "set fileformat=unix"
  callback = function()
    if vim.bo.modifiable and not vim.bo.readonly then
      vim.bo.fileformat = "unix"
    end
  end
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    if client.supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end
      })
    end
  end
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, { buffer = event.buffer })

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      --             vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      --                 buffer = event.buf,
      --                 group = highlight_augroup,
      --                 callback = vim.lsp.buf.document_highlight,
      --             })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- The following autocommand is used to enable inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

vim.api.nvim_create_autocmd('LspDetach', {
  group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
  callback = function(event)
    vim.lsp.buf.clear_references()
    vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event.buf }
  end,
})
