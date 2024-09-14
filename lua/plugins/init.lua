return 
{
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require "configs.nvimtree"
    end,

  },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "powershell -ExecutionPolicy Bypass -File Build-LuaTiktoken.ps1", -- This is Optional, only if you want to use tiktoken_core to calculate tokens count
    -- rest of the config
    opts = {
      -- add any opts here
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below is optional, make sure to setup it properly if you have lazy=true
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },

  {
    "nyngwang/NeoZoom.lua",
    event = "BufRead",
    config = function()
      require("neo-zoom").setup()
    end,

  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
--
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp" ,
        "prettier"
      },
    },
  },

  {
     "williamboman/mason-lspconfig.nvim",
     event = "BufRead",
     opts = function()
         return require "configs.mason-lspconfig"
     end,

     config = function(_, opts)
         require("mason-lspconfig").setup(opts)
     end,
  },
--
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "cpp",
        "c",
      },
    },
  },

  {
    "p00f/clangd_extensions.nvim",
    ft = {"c", "cpp"}
  },

  {
    'piersolenski/telescope-import.nvim',
    dependencies = 'nvim-telescope/telescope.nvim',
    config = function()
      require("telescope").load_extension("import")
    end
  }
}
