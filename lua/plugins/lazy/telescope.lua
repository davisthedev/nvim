return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.6',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build =
      'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
      cond = function()
        return vim.fn.executable 'make' == 0 and vim.fn.executable 'cmake' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons',            enabled = true },
  },
  config = function()
    local function find_project_root()
      local buffer_dir = require('telescope.utils').buffer_dir()
      local patterns = { '.git' }
      for _, pattern in ipairs(patterns) do
        local root = vim.fn.finddir(pattern, buffer_dir .. ';')
        if root ~= '' then
          return vim.fn.fnamemodify(root, ':h')
        end
      end
      return buffer_dir
    end

    local function find_local_root()
      local buffer_dir = require('telescope.utils').buffer_dir()
      local patterns = { 'package.json' }
      for _, pattern in ipairs(patterns) do
        local root = vim.fn.finddir(pattern, buffer_dir .. ';')
        if root ~= '' then
          return vim.fn.fnamemodify(root, ':h')
        end
      end
      return buffer_dir
    end

    require('telescope').setup({
      defaults = {
        cwd = find_project_root,
        find_command = { 'rg', '--files', '--hidden', '--follow', '--no-ignore', '--glob', '!.git/*' },
        file_ignore_patterns = { "node_modules", ".git" }
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    })

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')


    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', function() builtin.find_files({ cwd = find_project_root() }) end,
      { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>lf', function() builtin.find_files({ cwd = find_local_root() }) end,
      { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', function() builtin.grep_string({ cwd = find_project_root() }) end,
      { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>lw', function() builtin.grep_string({ cwd = find_local_root() }) end,
      { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', function() builtin.live_grep({ cwd = find_project_root() }) end,
      { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>lg', function() builtin.live_grep({ cwd = find_local_root() }) end,
      { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
