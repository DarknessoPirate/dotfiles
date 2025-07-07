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

      -- Add all the tools we want to auto-install
      vim.list_extend(opts.ensure_installed, {
        -- Language Servers
        "clangd", -- C++ Language Server
        "glslls", -- GLSL Language Server for OpenGL shaders
        "omnisharp", -- C# Language Server (if not already installed)

        -- Formatters
        "clang-format", -- C++ formatter
        "csharpier", -- C# formatter (optional)

        -- Linters
        "cpplint", -- C++ linter
        "cppcheck", -- C++ static analysis

        -- Debuggers
        "codelldb", -- C++ debugger
        "netcoredbg", -- C# debugger (optional)

        -- Additional useful tools
        "cmake-language-server", -- CMake LSP (for CMakeLists.txt files)
        "marksman", -- Markdown LSP (useful for documentation)
      })

      return opts
    end,
  },

  -- Optional: Add syntax highlighting plugins
  {
    "tikhomirov/vim-glsl",
    ft = { "glsl", "vert", "frag", "geom", "tesc", "tese", "comp" },
    config = function()
      -- GLSL file type detection (moved from astrolsp to avoid conflicts)
      vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = {
          "*.vs",
          "*.fs",
          "*.gs",
          "*.tcs",
          "*.tes",
          "*.comp",
          "*.vert",
          "*.frag",
          "*.geom",
          "*.tesc",
          "*.tese",
          "*.glsl",
        },
        callback = function() vim.bo.filetype = "glsl" end,
        desc = "Set GLSL filetype for shader files",
      })
    end,
  },

  -- Optional: Enhanced clangd experience
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
