require "nvchad.options"

local osname = require "util.os_name"
local name, _ = osname.get_os_name()

-- add yours here!
if name == "Windows" then
  vim.g.clipboard = "win32yank"
end
-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
