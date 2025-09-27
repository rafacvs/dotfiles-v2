-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>W", ":w!<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>q", ":q<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>Q", ":q!<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>Ç", ":", { noremap = true, silent = true })

-- Buffer management (LazyVim style)
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>[b", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>]b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bw", "<cmd>bwipeout<CR>", { desc = "Wipeout buffer" })
vim.keymap.set("n", "<leader>bo", "<cmd>%bdelete|edit #|bdelete #<CR>", { desc = "Close other buffers" })

-- Window Management
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

vim.keymap.set("n", "<C-w>w", "<C-w>w", { desc = "Toggle between windows" })

-- Window resizing
vim.keymap.set("n", "<C-w>=", "<C-w>=", { desc = "Make windows equal size" })
vim.keymap.set("n", "<C-w>+", "<C-w>+", { desc = "Increase window height" })
vim.keymap.set("n", "<C-w>-", "<C-w>-", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-w>>", "<C-w>>", { desc = "Increase window width" })
vim.keymap.set("n", "<C-w><", "<C-w><", { desc = "Decrease window width" })

-- Telescope keymaps
vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Find help" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Find recent files" })
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope colorscheme<CR>", { desc = "Find colorscheme" })

-- LSP keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show diagnostics" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep_args<CR>", { desc = "Search with args" })
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")     -- move line up(n)
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")     -- move line down(n)
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv") -- move line up(v)
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv") -- move line down(v)

vim.keymap.set("n", "<leader>bt", function()
  if vim.o.showtabline == 0 then
    vim.o.showtabline = 2
  else
    vim.o.showtabline = 0
  end
end, { desc = "Toggle Bufferline" })

vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>", { desc = "Open MarkdownPreview" })
vim.keymap.set("n", "<leader>M", ":VimathRun<CR>", { desc = "Runs vimath.nvim" })

vim.keymap.set("n", "<leader>ms", function()
  vim.cmd("rightbelow vnew")
  local buf = vim.api.nvim_get_current_buf()

  local bo = vim.bo[buf]
  bo.buftype = "nofile"
  bo.bufhidden = "wipe"
  bo.swapfile = false
  bo.modifiable = true

  local messages = vim.fn.execute("messages")
  vim.api.nvim_buf_set_lines(buf, 0, 1, false, vim.split(messages, "\n"))

  vim.cmd("normal! gg")
  vim.cmd("normal! dd")
end, { desc = "Show Neovim messages in a vertical split" })

local function reload_module(name)
  package.loaded[name] = nil
  return require(name)
end

local function reload_config_modules(prefix)
  for name, _ in pairs(package.loaded) do
    if name:match("^" .. prefix) then
      package.loaded[name] = nil
    end
  end
end

local function source_nvim()
  local ok, err = pcall(function()
    reload_config_modules("core")
    package.loaded["plugins"] = nil
    require("core.options")
    require("core.keymaps")
    require("core.autocmds")
    require("plugins")
    vim.notify("Neovim config reloaded!", vim.log.levels.INFO)
  end)
  if not ok then
    vim.notify("Error reloading config: " .. err, vim.log.levels.ERROR)
  end
end
vim.keymap.set("n", "<Leader>r", source_nvim, { desc = "Reload Neovim config" })

vim.keymap.set("n", "<leader>cs", ":colorscheme ", { noremap = true })

vim.keymap.set('i', 'jk', '<Esc>', { noremap = true, silent = true })
