local function make_neovim_transparent()
	vim.cmd([[
    hi Normal guibg=NONE ctermbg=NONE
    hi NormalNC guibg=NONE ctermbg=NONE
    hi StatusLine guibg=NONE ctermbg=NONE
    hi StatusLineNC guibg=NONE ctermbg=NONE
    hi TabLine guibg=NONE ctermbg=NONE
    hi TabLineSel guibg=NONE ctermbg=NONE
    hi TabLineFill guibg=NONE ctermbg=NONE
  ]])
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = make_neovim_transparent,
})

vim.schedule(make_neovim_transparent)
