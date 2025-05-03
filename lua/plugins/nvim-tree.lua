return {
  "nvim-tree/nvim-tree.lua",
  opts = {
    git = {
      enable = true,
    },

    view = {
      adaptive_size = true,
    },

    renderer = {
      highlight_git = true,
      icons = {
        show = {
          git = true,
        },
      },
    },
  },
}
