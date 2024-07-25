-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<cr>', { desc = 'Split window vertically' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Define key mappings for normal mode to execute Ex commands.
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- Define key mappings for visual mode to move lines down and up.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Define key mappings for normal mode to join lines.
vim.keymap.set("n", "J", "mzJ`z")

-- Define key mappings for scrolling half page down and up.
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Improve navigation with 'n' and 'N' by centering the cursor vertically after the jump.
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Define a key mapping for pasting without overwriting the default register.
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Define key mappings for yanking lines and entire lines to the system clipboard.
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+Y]])

-- Define a key mapping for deleting lines without overwriting the default register.
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Define a key mapping for exiting insert mode with jk.
vim.keymap.set("i", "jk", "<Esc><right>")

-- Define key mappings for custom functionality and skipping the Q command.
vim.keymap.set("n", "Q", "<nop>")

-- Define key mappings for running LSP format command and moving through quickfix and location lists.
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Define a key mapping for performing a case-insensitive search and replace.
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Define a key mapping to source the current file.
vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end)

-- Custom functions
vim.keymap.set('n', '<leader>cl', '<cmd>lua require("config.functions").logVariable()<cr>', { desc = '[C]onsole [L]og' })
