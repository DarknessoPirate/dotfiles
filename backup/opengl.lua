-- Enhanced C++ clangd configuration for AstroVim
-- Add this to your existing OpenGL config or create a separate C++ config file

return {
  -- Mason: Install clangd and related tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "clangd", -- C++ Language Server (THE best one)
        "clang-format", -- C++ Code formatter
        "codelldb", -- C++ Debugger (optional but excellent)
        "cpplint", -- C++ Linter (optional)
        "cppcheck", -- Static analysis tool (optional)
      })
      return opts
    end,
  },

  -- AstroLSP: Configure clangd with optimal settings
  {
    "AstroNvim/astrolsp",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- Clangd configuration optimized for modern C++ development
      opts.servers.clangd = {
        cmd = {
          "clangd",
          "--background-index", -- Index in background for better performance
          "--clang-tidy", -- Enable clang-tidy integration
          "--header-insertion=iwyu", -- Smart header insertion
          "--completion-style=detailed", -- Detailed completion info
          "--function-arg-placeholders", -- Show parameter placeholders
          "--fallback-style=llvm", -- Default formatting style
          "--all-scopes-completion", -- Complete from all accessible scopes
          "--cross-file-rename", -- Enable cross-file renaming
          "--log=verbose", -- Detailed logging (remove if too noisy)
          "--pretty", -- Pretty-print JSON output
        },

        -- File types that clangd should handle
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },

        -- Root directory detection - where clangd looks for project config
        root_dir = function(fname)
          local util = require "lspconfig.util"
          return util.root_pattern(
            "compile_commands.json", -- CMake compilation database
            "compile_flags.txt", -- Simple flags file
            ".clangd", -- clangd config file
            "CMakeLists.txt", -- CMake project
            "Makefile", -- Make project
            "configure.ac", -- Autotools
            "meson.build", -- Meson
            ".git" -- Git repository
          )(fname) or util.path.dirname(fname)
        end,

        -- Initialization options
        init_options = {
          usePlaceholders = true, -- Use placeholders in completions
          completeUnimported = true, -- Complete unimported symbols
          clangdFileStatus = true, -- Show file status in statusline
        },

        -- Additional capabilities
        capabilities = {
          textDocument = {
            completion = {
              editsNearCursor = true, -- Allow edits near cursor during completion
            },
          },
          offsetEncoding = { "utf-16" }, -- Use UTF-16 encoding (clangd preference)
        },

        -- Custom settings for clangd
        settings = {
          clangd = {
            -- Enable inlay hints for parameter names, types, etc.
            InlayHints = {
              Designators = true,
              Enabled = true,
              ParameterNames = true,
              DeducedTypes = true,
            },
            -- Enable semantic highlighting
            semanticHighlighting = true,
          },
        },
      }

      return opts
    end,
  },

  -- Optional: Add clangd extensions for even better experience
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp", "cuda" },
    config = function()
      require("clangd_extensions").setup {
        -- Enable inlay hints
        inlay_hints = {
          inline = false, -- Don't show inline (can be cluttered)
          only_current_line = false,
          only_current_line_autocmd = "CursorHold",
          show_parameter_hints = true,
          parameter_hints_prefix = "<- ",
          other_hints_prefix = "=> ",
          max_len_align = false,
          max_len_align_padding = 1,
          right_align = false,
          right_align_padding = 7,
          highlight = "Comment",
          priority = 100,
        },

        -- AST (Abstract Syntax Tree) viewer - useful for debugging
        ast = {
          role_icons = {
            type = "🄣",
            declaration = "🄓",
            expression = "🄔",
            statement = "🄢",
            specifier = "🄢",
            ["template argument"] = "🆃",
          },
          kind_icons = {
            Compound = "🄲",
            Recovery = "🅁",
            TranslationUnit = "🅄",
            PackExpansion = "🄿",
            TemplateTypeParm = "🅃",
            TemplateTemplateParm = "🅃",
            TemplateParamObject = "🅃",
          },
          highlights = {
            detail = "Comment",
          },
        },

        -- Memory usage display
        memory_usage = {
          border = "none",
        },

        -- Symbol info display
        symbol_info = {
          border = "none",
        },
      }
    end,
  },

  -- Optional: Configure formatting with clang-format
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.cpp = { "clang-format" }
      opts.formatters_by_ft.c = { "clang-format" }
      return opts
    end,
  },

  -- Optional: Add C++ specific keymaps
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings

      -- C++ specific mappings (only active in C++ files)
      maps.n["<leader>ch"] = {
        "<cmd>ClangdSwitchSourceHeader<cr>",
        desc = "Switch between .h and .cpp files",
      }
      maps.n["<leader>ct"] = {
        "<cmd>ClangdTypeHierarchy<cr>",
        desc = "Show type hierarchy",
      }
      maps.n["<leader>cs"] = {
        "<cmd>ClangdSymbolInfo<cr>",
        desc = "Show symbol info",
      }
      maps.n["<leader>cm"] = {
        "<cmd>ClangdMemoryUsage<cr>",
        desc = "Show clangd memory usage",
      }

      return opts
    end,
  },
}
