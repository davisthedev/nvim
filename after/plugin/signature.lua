local lsp_signature = require 'lsp_signature'

lsp_signature.setup {
  bind = true,
  fix_pos = true,
  floating_window_above_cur_line = true,
  floating_window_off_y = 0,
  handler_opts = {
    border = "rounded"
  },
  hi_parameter = "LspSignatureActiveParameter",
  hint_prefix = " ",
  noice = true,
}
