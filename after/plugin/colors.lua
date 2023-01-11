function SetNvimTheme(color)
	color = color or "catppuccin-mocha"
	vim.cmd.colorscheme(color)
end

SetNvimTheme()

