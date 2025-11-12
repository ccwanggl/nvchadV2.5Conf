local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    cpp = { "clang_format" },

    sh = { "shfmt" },

    python = { "isort", "black" },

    rust = { "rustfmt" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  formatters = {
    clang_format = {
      prepend_args = { "--style=file", "--fallback-style=LLVM" },
    },

    isort = {
      include_trailing_comma = true,
      command = "isort",
      args = {
        "--line-length",
        "120",
        "--lines-after-import",
        "2",
        "--quiet",
        "-",
      },
    },
    black = {
      command = "black",
      args = {
        "--line-length",
        "120",
        "--quiet",
        "-",
      },
    },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
