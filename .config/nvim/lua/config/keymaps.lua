-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local fzf_lua = require("fzf-lua")

-- Helper function to build options for each ignore profile
local function fzf_with_ignore(profile)
  local ignores = vim.g.fzf_ignore_profiles or {}
  local build_opts = vim.g.fzf_ignore_build_opts
  local path = ignores[profile] or ignores.default
  if not path then
    vim.notify("No ignore profiles configured!", vim.log.levels.ERROR)
    return
  end
  local fd_opts, _ = build_opts(path)
  fzf_lua.files({ fd_opts = fd_opts })
end

-- Helper function for grep functionality
local function fzf_with_grep(profile)
  local ignores = vim.g.fzf_ignore_profiles or {}
  local build_opts = vim.g.fzf_ignore_build_opts
  local path = ignores[profile] or ignores.default
  if not path then
    vim.notify("No ignore profiles configured!", vim.log.levels.ERROR)
    return
  end
  local _, rg_opts = build_opts(path)
  fzf_lua.live_grep({ rg_opts = rg_opts }) 
end

vim.keymap.del("n", "<leader>/")

-- Key mappings for fzf-lua files
vim.keymap.set("n", "<leader>fd", function() fzf_with_ignore("default") end, { desc = "FZF Files (Default Ignore)" })
vim.keymap.set("n", "<leader>fs", function() fzf_with_ignore("small") end, { desc = "FZF Files (Small Ignore)" })
vim.keymap.set("n", "<leader>fb", function() fzf_with_ignore("big") end, { desc = "FZF Files (Big Ignore)" })

-- Key mappings for fzf-lua grep
vim.keymap.set("n", "<leader>/d", function() fzf_with_grep("default") end, { desc = "FZF Grep (Default Ignore)" })
vim.keymap.set("n", "<leader>/s", function() fzf_with_grep("small") end, { desc = "FZF Grep (Small Ignore)" })
vim.keymap.set("n", "<leader>/b", function() fzf_with_grep("big") end, { desc = "FZF Grep (Big Ignore)" })


  