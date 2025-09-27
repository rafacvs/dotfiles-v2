vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.g.snacks_animate = false
vim.g.root_spec = { "cwd" }

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.termguicolors = true
vim.opt.wrap = true

vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.foldenable = true
vim.opt.foldcolumn = "0"
vim.opt.fillchars = {
	fold = " ",
	foldopen = "▼",
	foldclose = "▶",
	foldsep = " ",
}

vim.diagnostic.config({
	signs = false,
	virtual_text = true,
})

-- persistent undo
local undo_dir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undo_dir) == 0 then
	vim.fn.mkdir(undo_dir, "p")
end
vim.o.undofile = true
vim.o.undodir = undo_dir

vim.o.ignorecase = true
vim.o.smartcase = true

vim.cmd("highlight CursorLine guibg=NONE ctermbg=NONE")
vim.o.cursorline = true

vim.opt.clipboard = "unnamedplus"
