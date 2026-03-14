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
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('gd', "<cmd>FzfLua lsp_definitions      jump_to_single_result=true ignore_current_line=true<cr>",
      "Goto Definition")
    map('gr', "<cmd>FzfLua lsp_references       jump_to_single_result=true ignore_current_line=true<cr>", "References")
    map('gI', "<cmd>FzfLua lsp_implementations  jump_to_single_result=true ignore_current_line=true<cr>",
      "Goto Implementation")
    map('gy', "<cmd>FzfLua lsp_typedefs         jump_to_single_result=true ignore_current_line=true<cr>",
      "Goto Type Definition")
    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, { buffer = event.buffer })

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method("textDocument/inlayHint") then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, "[T]oggle Inlay [H]ints")
      vim.lsp.inlay_hint.enable(true)
    end
  end,
})
