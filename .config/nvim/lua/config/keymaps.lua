-- keymaps.lua

local fzf_lua = require("fzf-lua")

-- Helper function to trigger fzf with the correct profile
local function fzf_files_profile(profile)
  local fd_opts = vim.g.get_fd_opts_for_profile(profile)
  if not fd_opts then return end
  require("fzf-lua").files({ fd_opts = fd_opts })
end

-- Helper function for grep functionality with profile
local function fzf_grep_profile(profile)
  local rg_opts = vim.g.get_rg_opts_for_profile(profile)
  if not rg_opts then return end
  require("fzf-lua").live_grep({ rg_opts = rg_opts })
end

vim.keymap.del("n", "<leader>/")

-- Key mappings for fzf-lua files with dynamic ignore profiles
vim.keymap.set("n", "<leader>fd", function() fzf_files_profile("Ignore1") end, { desc = "Find Files (Ignore1 Profile)" })

-- Key mappings for fzf-lua grep with dynamic ignore profiles
vim.keymap.set("n", "<leader>/d", function() fzf_grep_profile("Ignore1") end, { desc = "Grep (Ignore1 Profile)" })
