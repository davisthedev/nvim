require('bufferline').setup({
  options = {
    show_buffer_icons = true,
    show_buffer_default_icon = true,
    diagnostics = 'nvim_lsp',
    max_prefix_length = 8,
    indicator = {
      icon = '▎', -- this should be omitted if indicator style is not 'icon'
      style = 'icon',
    },
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
  }
})
