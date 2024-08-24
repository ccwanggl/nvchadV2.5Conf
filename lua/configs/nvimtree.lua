local options =  {
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

require ("nvim-tree").setup(options)
