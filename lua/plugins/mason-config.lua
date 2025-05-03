return {
     "williamboman/mason-lspconfig.nvim",
     event = "BufRead",
     opts = function()
         return require "configs.mason-lspconfig"
     end,

     config = function(_, opts)
         require("mason-lspconfig").setup(opts)
     end,
  }
