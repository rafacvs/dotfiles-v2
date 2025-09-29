return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false, -- load during startup
    priority = 1000,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false, -- load during startup
    priority = 1000,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    -- config = function()
    --   vim.o.background = "dark"
    --   vim.cmd([[colorscheme gruvbox]])
    -- end,
  },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod",                     lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.dbs = {
        -- DO NOT COMMIT DB CREDENTIALS
      }
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = { "markdown" },
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    init = function()
      -- do not auto close preview when switching buffers
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_refresh_slow = 0
    end,
  },
  {
    "kelly-lin/ranger.nvim",
    config = function()
      local ranger = require("ranger-nvim")
      ranger.setup({
        replace_netrw = true,
        float = false,
        enable_cmds = true, -- habilita comandos do ranger
        keybinds = {},      -- você pode deixar vazio para usar padrão
        ui = {
          border = "none",
          height = 0.85,
          width = 0.85,
          x = 0.5,
          y = 0.5,
        },
      })

      vim.api.nvim_set_keymap("n", "<leader>e", "", {
        noremap = true,
        callback = function()
          ranger.open(true)
        end,
        desc = "Abrir Ranger",
      })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    keys = function(_, keys)
      local lga = require("telescope").extensions.live_grep_args
      local builtin = require("telescope.builtin")

      return vim.list_extend(keys, {
        {
          "<leader>sg",
          function()
            lga.live_grep_args({
              cwd = vim.fn.getcwd(), -- Adiciona esta linha para usar o CWD atual
            })
          end,
          desc = "Live Grep Args",
        },
        {
          "<leader>,",
          function()
            builtin.buffers({
              previewer = false,
              initial_mode = "normal",
            })
          end,
          desc = "Buffer",
        },
      })
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      local actions = require("telescope.actions.layout")

      local opts_override = vim.tbl_deep_extend("force", opts or {}, {
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "bottom",
              preview_width = 0.65,
              results_width = 0.35,
            },
            width = 0.95,
            height = 0.90,
            preview_cutoff = 1,
          },
          mappings = {
            i = {
              ["<C-p>"] = actions.toggle_preview,
            },
            n = {
              ["<C-p>"] = actions.toggle_preview,
            },
          },
        },
        pickers = {
          lsp_references = {
            initial_mode = "normal",
          },
          find_files = {
            hidden = true
          }
        },
      })

      telescope.setup(opts_override)
      telescope.load_extension("live_grep_args")
    end,
  },
  {
    dir = "LOCAL_DEV_DIR_DO_NOT_COMMIT", -- absolute path to your local plugin
    name = "vimath",                                      -- optional, helps with identification
    config = function()
      require("vimath").setup()                           -- if your plugin exposes setup()
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      preset = "helix"
    },
  },
  { 'nvim-treesitter/nvim-treesitter-context' },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "javascript", "typescript", "go", "c_sharp" },
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,
        modules = {},
        sync_install = false,
        ignore_install = {},
      })

      require("treesitter-context").setup({
        enable = true,
        max_lines = 2,
        min_window_height = 0,
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "gopls", "omnisharp" },
        automatic_installation = true,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local servers = { "ts_ls", "gopls", "omnisharp" }

      for _, server in ipairs(servers) do
        local config = vim.lsp.config[server]
        if config then
          config.capabilities = capabilities
          vim.lsp.start(config)
        end
      end
    end,
  },
  -- {
  -- 	"nvim-lualine/lualine.nvim",
  -- 	dependencies = { "nvim-tree/nvim-web-devicons" },
  -- 	config = function()
  -- 		require("lualine").setup({
  -- 			options = { theme = "gruvbox" },
  -- 		})
  -- 	end,
  -- },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP completion source
      "hrsh7th/cmp-buffer",   -- buffer completions
      "hrsh7th/cmp-path",     -- path completions
      "hrsh7th/cmp-cmdline",  -- cmdline completions
      "L3MON4D3/LuaSnip",     -- snippets
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),            -- trigger completion
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- enter selects
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  }
}
