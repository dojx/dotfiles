return {
  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",  -- Ensure it's loaded on startup
    opts = function(_, opts)
      -- Load and parse the JSON configuration file
      local function load_ignore_profiles()
        local ignore_file_path = vim.fn.expand("$HOME/.config/ignore/ignore_config.json")
        local file_content = vim.fn.readfile(ignore_file_path)
        if #file_content == 0 then return {} end
        local content_str = table.concat(file_content, "\n")
        local ok, data = pcall(vim.fn.json_decode, content_str)
        if not ok then
          vim.notify("Error parsing ignore config JSON", vim.log.levels.ERROR)
          return {}
        end
        return data
      end

      -- Helper to build fd opts dynamically based on JSON profiles
      local function build_fd_opts_from_json(profile)
        local include_patterns = type(profile.include) == "table" and profile.include or {}
        local exclude_patterns = type(profile.exclude) == "table" and profile.exclude or {}

        -- Build fd options
        local fd_opts = {"--color=never", "--hidden", "--follow"}
        for _, pattern in ipairs(include_patterns) do
          -- Use -e flag for file extensions
          table.insert(fd_opts, "-e")
          table.insert(fd_opts, pattern)
        end
        for _, pattern in ipairs(exclude_patterns) do
          table.insert(fd_opts, "-E")
          table.insert(fd_opts, pattern)
        end

        -- Convert fd_opts to a space-separated string
        fd_opts = table.concat(fd_opts, " ")

        return fd_opts
      end

      -- Helper to build rg opts dynamically based on JSON profiles
      local function build_rg_opts_from_json(profile)
        local include_patterns = type(profile.include) == "table" and profile.include or {}
        local exclude_patterns = type(profile.exclude) == "table" and profile.exclude or {}

        -- Build rg options
        local rg_opts = "--color=never --no-heading --with-filename --line-number --column --smart-case --hidden --trim --max-filesize 1M --binary"
        for _, pattern in ipairs(include_patterns) do
          rg_opts = rg_opts .. " --glob '*" .. pattern .. "'"
        end
        for _, pattern in ipairs(exclude_patterns) do
          rg_opts = rg_opts .. " --glob '!" .. pattern .. "**'"
        end

        return rg_opts
      end

      -- Load ignore profiles from the JSON file
      local profiles = load_ignore_profiles()

      -- Helper function to get fd options for a given profile
      vim.g.get_fd_opts_for_profile = function(profile)
        local ignore_profile = profiles[profile] or profiles.Ignore1
        if not ignore_profile then
          vim.notify("No fzf profile configured!", vim.log.levels.ERROR)
          return nil, nil
        end
        return build_fd_opts_from_json(ignore_profile)
      end

      -- Helper function to get rg options for a given profile
      vim.g.get_rg_opts_for_profile = function(profile)
        local ignore_profile = profiles[profile] or profiles.Ignore1
        if not ignore_profile then
          vim.notify("No fzf profile configured!", vim.log.levels.ERROR)
          return nil, nil
        end
        return build_rg_opts_from_json(ignore_profile)
      end

      -- Set default options for fzf-lua when loading normally
      opts.files = opts.files or {}
      opts.grep = opts.grep or {}
      opts.live_grep = opts.live_grep or {}

      -- Build options for default profile
      local fd_opts = vim.g.get_fd_opts_for_profile("Ignore1")  -- Default to Ignore1 profile
      local rg_opts = vim.g.get_rg_opts_for_profile("Ignore1")  -- Default to Ignore1 profile

      opts.files.fd_opts = fd_opts
      opts.grep.rg_opts = rg_opts
      opts.live_grep.rg_opts = rg_opts
    end,
  },
}