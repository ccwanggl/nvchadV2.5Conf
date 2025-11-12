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
        "--profile",
        "black",
        "-",
      },
    },
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
