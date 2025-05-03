return {
    "chrisgrieser/nvim-recorder",
    event = "BufRead",
    dependencies = "rcarriga/nvim-notify", -- optional
    opts = {}, -- required even with default settings, since it calls `setup()`
  }
