return {
    "nvim-tree/nvim-tree.lua",
    opts = {
      git = {
        enable = false,
      },

      view = {
        adaptive_size = true,
      },

      renderer = {
        highlight_git = false,
        icons = {
          show = {
            git = false,
          },
        },
      },
    }
  }
