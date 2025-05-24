return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- optional for file icons
  },
  config = function()
    local fzf = require("fzf-lua")

    local function find_project_root()
      local buffer_dir = vim.fn.expand("%:p:h")
      local patterns = { ".git", "Makefile", "package.json", "go.mod", "svelte.config.js", "vue.config.js", "CMakeLists.txt", ".cargo" }
      for _, pattern in ipairs(patterns) do
        local root = vim.fn.finddir(pattern, buffer_dir .. ";")
        if root ~= "" then
          return vim.fn.fnamemodify(root, ":h")
        end
      end
      return vim.loop.cwd() or buffer_dir
    end

    local function find_local_root()
      local buffer_dir = vim.fn.expand("%:p:h")
      local patterns = { "package.json", "pyproject.toml", "Cargo.toml", "go.mod", "svelte.config.js", "vue.config.js", "CMakeLists.txt" }
      for _, pattern in ipairs(patterns) do
        local root = vim.fn.findfile(pattern, buffer_dir .. ";")
        if root ~= "" then
          return vim.fn.fnamemodify(root, ":h")
        end
      end
      return find_project_root() -- Default to project root if no local root is found
    end

    local is_windows = vim.fn.has("win32") == 1
    local rg_cmd = is_windows and "rg.exe" or "rg"

    fzf.setup {
      winopts = {
        -- split = "belowright new", -- open in a new split
      },
      files = {
        cmd = rg_cmd .. " --files --hidden --follow --glob \"!.git/*\" --ignore-file .gitignore --iglob \"!node_modules/*\"",
        file_ignore_patterns = { "node_modules", ".git" },
      },
      grep = {
        rg_opts = "--hidden --follow --glob \"!.git/*\" --ignore-file .gitignore --iglob \"!node_modules/*\" --fixed-strings",
      },
      keymap = {
        fzf = {
          ["ctrl-t"] = "toggle-preview", -- Example keymap for fzf preview
        },
      },
    }

    -- Key mappings
    vim.keymap.set('n', '<leader>sh', function() fzf.help_tags() end, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', function() fzf.keymaps() end, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>pf', function() fzf.files({ cwd = find_project_root() }) end,
      { desc = '[S]earch [F]iles (Project Root)' })
    vim.keymap.set('n', '<leader>sf', function() fzf.files({ cwd = find_local_root() }) end,
      { desc = '[S]earch [F]iles (Local Root)' })
    vim.keymap.set('n', '<leader>pg', function() fzf.live_grep({ cwd = find_project_root() }) end,
      { desc = '[S]earch by [G]rep (Project Root)' })
    vim.keymap.set('n', '<leader>sg', function() fzf.live_grep({ cwd = find_local_root() }) end,
      { desc = '[S]earch by [G]rep (Local Root)' })
    vim.keymap.set('n', '<leader>pw', function() fzf.grep_cword({ cwd = find_project_root() }) end,
      { desc = '[S]earch current [W]ord (Project Root)' })
    vim.keymap.set('n', '<leader>sw', function() fzf.grep_cword({ cwd = find_local_root() }) end,
      { desc = '[S]earch current [W]ord (Local Root)' })
    vim.keymap.set('n', '<leader>sd', function() fzf.diagnostics() end, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', function() fzf.resume() end, { desc = '[S]earch [R]esume Last' })
    vim.keymap.set('n', '<leader>s.', function() fzf.oldfiles() end, { desc = '[S]earch Recent Files' })
    vim.keymap.set('n', '<leader>sb', function() fzf.buffers() end, { desc = '[S]earch Buffers' })
    vim.keymap.set('n', '<leader>s/', function()
      fzf.live_grep { grep_open_files = true, prompt = "Live Grep in Open Files > ", rg_opts = "--hidden --follow --ignore-file .gitignore --iglob \"!node_modules/*\" --fixed-strings" }
    end, { desc = '[S]earch [/] in Open Files' })
    vim.keymap.set('n', '<leader>sn', function()
      fzf.files { cwd = vim.fn.stdpath('config') }
    end, { desc = '[S]earch [N]eovim Config Files' })

    -- Current buffer search
    vim.keymap.set('n', '<leader>/', function()
      fzf.blines()
    end, { desc = '[/] Fuzzily search in current buffer' })
  end,
}