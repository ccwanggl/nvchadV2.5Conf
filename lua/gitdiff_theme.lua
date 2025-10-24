-- lua/gitdiff_theme.lua
-- Git-only vimdiff theme (Gruvbox dark), window-local & non-invasive

local M = {}

local function palette()
  return {
    add_bg    = "#32361a",
    add_fg    = "#b8bb26",
    chg_bg    = "#3c3836",
    chg_fg    = "#d79921",
    del_bg    = "#3c1f1e",
    del_fg    = "#fb4934",
    text_bg   = "#504945",
    gutter_bg = "NONE",
  }
end

local function apply_winhl(win)
  if not vim.api.nvim_win_is_valid(win) then return end
  if not vim.wo[win].diff then return end

  if not vim.opt.termguicolors:get() then
    vim.opt.termguicolors = true
  end

  local C = palette()

  vim.api.nvim_set_hl(0, "GitDiffAdd",    { fg = C.add_fg, bg = C.add_bg })
  vim.api.nvim_set_hl(0, "GitDiffChange", { fg = C.chg_fg, bg = C.chg_bg })
  vim.api.nvim_set_hl(0, "GitDiffDelete", { fg = C.del_fg, bg = C.del_bg })
  vim.api.nvim_set_hl(0, "GitDiffText",   { fg = "NONE",   bg = C.text_bg, bold = true })
  vim.api.nvim_set_hl(0, "GitDiffGutter", { fg = "NONE",   bg = C.gutter_bg })

  local cur = vim.wo[win].winhl
  local map = table.concat({
    "DiffAdd:GitDiffAdd",
    "DiffChange:GitDiffChange",
    "DiffDelete:GitDiffDelete",
    "DiffText:GitDiffText",
    "SignColumn:GitDiffGutter",
    "FoldColumn:GitDiffGutter",
  }, ",")

  vim.wo[win].winhl = (cur ~= "" and (cur .. ",") or "") .. map

  -- diff 观感（仅该窗口/缓冲）
  vim.wo[win].wrap = false
  vim.wo[win].cursorline = false
  vim.opt_local.fillchars:append({ diff = "╱" })

  local dopts = vim.opt_local.diffopt
  dopts:append({ "internal", "algorithm:histogram", "vertical", "context:3" })
  if vim.fn.has("nvim-0.9") == 1 then
    dopts:append("linematch:60")
  end
end

local function refresh_all_diff_wins()
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    pcall(apply_winhl, w)
  end
end

function M.setup()
  local aug = vim.api.nvim_create_augroup("GitOnlyDiffTheme", { clear = true })

  vim.api.nvim_create_autocmd({ "VimEnter", "BufWinEnter", "WinEnter", "WinNew" }, {
    group = aug,
    callback = refresh_all_diff_wins,
  })

  vim.api.nvim_create_autocmd("OptionSet", {
    group = aug,
    pattern = "diff",
    callback = function() pcall(apply_winhl, 0) end,
  })

  if vim.fn.has("nvim-0.9") == 1 then
    vim.api.nvim_create_autocmd("DiffUpdated", { group = aug, callback = refresh_all_diff_wins })
  end

  vim.api.nvim_create_autocmd("ColorScheme", { group = aug, callback = refresh_all_diff_wins })

  vim.api.nvim_create_user_command("RediffTheme", refresh_all_diff_wins, {})
end

return M

