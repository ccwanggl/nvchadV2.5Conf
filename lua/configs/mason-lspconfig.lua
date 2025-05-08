local osname = require("util.os_name")
local name, _ = osname.get_os_name()

local options =
{
    ensure_installed = {
        "lua_ls",
        "pyright",
        "clangd",
        "neocmake",
        "bashls",
        "rust_analyzer",
        "marksman",
        "eslint",
        "slint_lsp",
        "jsonls",
        "yamlls",
        "powershell_es",
        "golangci_lint_ls",
        "nil_ls",
        "ts_ls",
        "ruff"
    },
}
if name == "Windows" then
    table.remove(options.ensure_installed, osname.tablefind(options.ensure_installed, "nil_ls"))
end


if (name == "Mac" or name == "Linux") then
    table.remove(options.ensure_installed, osname.tablefind(options.ensure_installed, "powershell_es"))
end

return options
