local conform = require "conform"

local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    cpp = { "clang_format" },

    sh = { "shfmt" },

    python = function(bufnr)
      if conform.get_formatter_info("ruff_format", bufnr).available then
        return { "ruff_fix", "ruff_format" }
      else
        return { "isort", "black" }
      end
    end,

    rust = { "rustfmt" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  formatters = {
    clang_format = {
      prepend_args = { "--style=file", "--fallback-style=LLVM" },
    },

    ruff_fix = {
      -- 追加 CLI 参数，例如使用 pyproject.toml：
      prepend_args = {}, -- { "--config", "pyproject.toml" }
    },
    ruff_format = {
      prepend_args = {}, -- { "--line-length", "100" }
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

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = true,
  },
}

return options
