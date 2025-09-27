vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text" },
	callback = function()
		vim.opt_local.spell = false
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "TelescopeResults", "TelescopePreview" },
	callback = function()
		vim.opt_local.number = true
		vim.opt_local.relativenumber = true
	end,
})

-- save colorscheme
-- Hardcode to your home config directory
local last_theme_file = vim.fn.expand("~/.config/nvim/last-theme.txt")
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.filereadable(last_theme_file) == 1 then
      local theme = vim.fn.readfile(last_theme_file)[1]
      if theme and theme ~= "" then
        vim.cmd.colorscheme(theme)
      end
    end
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.fn.writefile({ vim.g.colors_name }, last_theme_file)
  end,
})
