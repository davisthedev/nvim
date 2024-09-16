if vim.fn.has "win32" == 1 then
  vim.opt.shell = "pwsh"
  vim.g.undotree_DiffCommand = vim.fn.stdpath "config" .. "\\bin\\diff.exe"
end
require('config.options')
require('config.keymap')
require('config.autocmd')
require('config.functions')
