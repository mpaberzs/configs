return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = 'v0.1.9',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  { "nvim-treesitter/nvim-treesitter", branch = 'master',   lazy = false,   build = ":TSUpdate" },
  {
    'numToStr/Comment.nvim'
  },
  "mbbill/undotree",
  "tpope/vim-fugitive",
  { "catppuccin/nvim",                 name = "catppuccin", priority = 1000 },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
  },
  { 'nvim-tree/nvim-web-devicons' },
  { "robitx/gp.nvim" },

  "tpope/vim-dadbod",
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      {
        'kristijanhusak/vim-dadbod-completion',
        -- ft = { 'sql', 'mysql', 'plsql' },
        ft = { 'mysql' -- FIXME: just to stop messing psql queries for now
        },
        lazy = true
      },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
      'DBUIExecuteQuery'
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = 0
      -- don't want dadbod-ui results to be auto-folded
      vim.opt.foldmethod = 'manual'
      vim.opt.foldenable = false
      vim.opt.foldlevelstart = 999
      --
    end,
    keys = {
      { '<C-g><C-g>', '<PLUG>(DBUI_ExecuteQuery)', desc = 'Execute query' },
      -- FIXME: keymap for executing visual line: doesn't work
      -- { 'v', '\'<,\'><C-g><C-g>', '<PLUG>(DBUI_ExecuteQuery)', desc = 'Execute query' }
    }
  },
  {
    "lewis6991/gitsigns.nvim"
  },
  {
    'Bekaboo/dropbar.nvim',
    -- optional, but required for fuzzy finder support
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    },
    config = function()
      local dropbar_api = require('dropbar.api')
      vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
      vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
      vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    end
  },
  {
    "prichrd/netrw.nvim",
    name = "netrw"
  },

  {
    'tpope/vim-rhubarb'
  },
  {
    'luisjure/csound-vim'
  },
  { 'puremourning/vimspector' },
  {
    "scalameta/nvim-metals",
    tag = "v0.9.x",
    version = "v0.9.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local metals_config = require("metals").bare_config()
      metals_config.on_attach = function(client, bufnr)
        -- your on_attach function
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/nvim-cmp' },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "ts_ls",
        "eslint",
        "rust_analyzer",
        -- "codelldb", -- FIXME
        "lua_ls",
        "marksman",
        "intelephense",
        -- "kotlin-lsp-server",   -- should be working with mason,
        "kotlin_lsp",
        "htmx"
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
}
