-- Mason configuration for auto-installing LSP servers, formatters, and linters
-- Save this as: ~/.config/astronvim/lua/plugins/mason.lua

---@type LazySpec
return {
  -- Configure Mason to auto-install tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- Ensure the ensure_installed table exists
      opts.ensure_installed = opts.ensure_installed or {}

      -- CRITICAL: Ensure registries are properly configured for nvim-java
      opts.registries = opts.registries or {}
      vim.list_extend(opts.registries, {
        "github:nvim-java/mason-registry", -- This MUST be first!
        "github:mason-org/mason-registry",
      })

      -- Add all the tools we want to auto-install
      vim.list_extend(opts.ensure_installed, {
        -- Language Servers
        "clangd", -- C++ Language Server
        "omnisharp", -- C# Language Server
        -- NOTE: jdtls will be installed automatically by nvim-java

        -- Formatters
        "clang-format", -- C++ formatter
        "csharpier", -- C# formatter

        -- Linters
        "cpplint", -- C++ linter
        "cppcheck", -- C++ static analysis

        -- Debuggers
        "codelldb", -- C++ debugger
        "netcoredbg", -- C# debugger

        -- Additional useful tools
        "cmake-language-server", -- CMake LSP
        "marksman", -- Markdown LSP
      })

      return opts
    end,
    -- CRITICAL: Proper config function that merges opts
    config = function(_, opts) require("mason").setup(opts) end,
  },

  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp", "cuda" },
    config = function()
      require("clangd_extensions").setup {
        inlay_hints = {
          inline = false,
          only_current_line = false,
          show_parameter_hints = true,
          parameter_hints_prefix = "<- ",
          other_hints_prefix = "=> ",
          highlight = "Comment",
        },
        ast = {
          role_icons = {
            type = "🄣",
            declaration = "🄓",
            expression = "🄔",
            statement = "🄢",
          },
        },
      }
    end,
  },
}
