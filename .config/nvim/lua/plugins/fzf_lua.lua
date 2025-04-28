return {
  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",  -- Ensure it's loaded on startup
    opts = function(_, opts)
      -- Setup ignore file profiles
      vim.g.fzf_ignore_profiles = {
        default = vim.fn.expand("$HOME/.config/ignore/vim-ignore"),
        small   = vim.fn.expand("$HOME/.config/ignore/vim-ignore-small"),
        big     = vim.fn.expand("$HOME/.config/ignore/vim-ignore-big"),
      }

      -- Helper to build fd/rg opts dynamically
      vim.g.fzf_ignore_build_opts = function(ignore_file)
        local fd_opts = string.format(
          "--color=never --type f --hidden --follow --exclude .git --ignore-file %s",
          ignore_file
        )
        local rg_opts = string.format(
          "--color=never --no-heading --with-filename --line-number --column --smart-case --hidden --trim --max-filesize 1M --binary --glob '!.git/' --ignore-file %s",
          ignore_file
        )
        return fd_opts, rg_opts
      end

      -- Set default options for fzf-lua when loading normally
      local build_opts = vim.g.fzf_ignore_build_opts
      local fd_opts, rg_opts = build_opts(vim.g.fzf_ignore_profiles.default)

      opts.files = opts.files or {}
      opts.files.fd_opts = fd_opts

      opts.grep = opts.grep or {}
      opts.grep.rg_opts = rg_opts

      opts.live_grep = opts.live_grep or {}
      opts.live_grep.rg_opts = rg_opts
    end,
  },
}
