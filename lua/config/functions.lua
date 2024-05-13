local M = {}

M.logVariable = function()
    -- Determine the file extension of the current buffer
    local fileExtension = vim.fn.expand('%:e')

    -- Define log statement formats for different languages
    local logFormats = {
        lua = 'print("%s: ", %s)',
        go = 'log.Printf("%%s = %%#v\\n", "%s", %%s)',
        js = 'console.log("%s: ", %s);',
        ts = 'console.log("%s: ", %s);',
        vue = 'console.log("%s: ", %s);',
        svelte = 'console.log("%s: ", %s);',
        rust = 'println!("%s: {:?}", %s);',
    }

    -- Select the appropriate format based on file extension
    local format = logFormats[fileExtension] or 'console.log("%s": %s)' -- Default to Lua print if no match

    -- Save the current cursor position
    local save_pos = vim.api.nvim_win_get_cursor(0)
    local row, col = save_pos[1], save_pos[2]

    -- Get the current line text
    local line = vim.api.nvim_get_current_line()
    local indentation = line:match("^(%s*)")

    -- Initialize the start (s) and end (e) of the variable to the cursor position
    local s, e = col + 1, col + 1

    -- Search backwards from the cursor for the start of the variable
    while s > 1 do
        if line:sub(s - 1, s - 1):match("[%$%.%w_]") then
            s = s - 1
        else
            break
        end
    end

    -- Search forwards from the cursor for the end of the variable
    while e <= #line do
        if line:sub(e, e):match("[%$%.%w_%[%]]") then
            e = e + 1
        else
            break
        end
    end

    -- Extract the full variable
    local fullVariable = line:sub(s, e - 1)

    -- Handling for arrays and objects that include indexing or key access
    if fullVariable:match("%[%d+%]$") then
        local varBase = fullVariable:match("^(.+)%[%d+%]$")
        local index = fullVariable:match("%[(%d+)%]$")
        fullVariable = string.format("%s[%s]", varBase, index)
    end

    -- Format the log statement
    local logStatement = string.format(format, fullVariable, fullVariable)

    logStatement = indentation .. logStatement

    -- Insert the formatted statement
    vim.api.nvim_buf_set_lines(0, row, row, false, { logStatement })
end

return M
