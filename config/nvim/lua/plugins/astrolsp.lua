-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
      signature_help = true,
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      -- EXISTING: Your C# OmniSharp configuration
      omnisharp = {
        cmd = { "omnisharp" },
        filetypes = { "cs", "vb" },
        root_dir = function(fname)
          return require("lspconfig.util").root_pattern("*.sln", "*.csproj", "omnisharp.json")(fname)
        end,
        organize_imports_on_format = true, -- Auto-organize using statements
        enable_import_completion = true, -- Suggests imports
        enable_roslyn_analyzers = true, -- Code analysis warnings

        -- FIXED: settings should be INSIDE omnisharp config
        settings = {
          omnisharp = {
            enableEditorConfigSupport = true, -- Respects .editorconfig files
            enableRoslynAnalyzers = true, -- Same as above
            enableImportCompletion = true, -- Same as above
            analyzeOpenDocumentsOnly = false, -- Analyze entire project, not just open files

            -- ADDED: This is the key part for organize imports!
            FormattingOptions = {
              EnableEditorConfigSupport = true,
              OrganizeImports = true, -- This should appear in :LspInfo
            },

            completion = {
              includeArgumentNames = true, -- Show parameter names in completion
              includeSnippets = true, -- Enable code snippets
            },
          },
        },
      },

      -- NEW: C++ clangd configuration
      clangd = {
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
          "--pretty", -- Pretty-print JSON output
          "--compile-commands-dir=build",
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
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
        init_options = {
          usePlaceholders = true, -- Use placeholders in completions
          completeUnimported = true, -- Complete unimported symbols
          clangdFileStatus = true, -- Show file status in statusline
        },
        capabilities = {
          textDocument = {
            completion = {
              editsNearCursor = true, -- Allow edits near cursor during completion
            },
          },
          offsetEncoding = { "utf-16" }, -- Use UTF-16 encoding (clangd preference)
        },
        settings = {
          clangd = {
            InlayHints = {
              Designators = true,
              Enabled = true,
              ParameterNames = true,
              DeducedTypes = true,
            },
            semanticHighlighting = true,
          },
        },
      },

      --  GLSL language server configuration
      glslls = {
        filetypes = { "glsl", "vert", "frag", "geom", "tesc", "tese", "comp" },
        settings = {
          -- Add any specific GLSL settings here if needed
        },
      },
    },
    -- customize how language servers are attached
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- the key is the server that is being setup with `lspconfig`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_codelens_refresh = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/codeLens",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "InsertLeave", "BufEnter" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
          end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {

        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
        ["<C-h>"] = {
          function() vim.lsp.buf.signature_help() end,
          desc = "Signature help",
          cond = "textDocument/signatureHelp",
        },
        ["<A-Space>"] = {
          function() end,
          desc = "Do nothing",
        },

        -- C++ specific mappings
        ["<leader>ch"] = {
          "<cmd>ClangdSwitchSourceHeader<cr>",
          desc = "Switch between .h and .cpp files",
          cond = function(client) return client.name == "clangd" end,
        },
        ["<leader>ct"] = {
          "<cmd>ClangdTypeHierarchy<cr>",
          desc = "Show type hierarchy",
          cond = function(client) return client.name == "clangd" end,
        },
        ["<leader>cs"] = {
          "<cmd>ClangdSymbolInfo<cr>",
          desc = "Show symbol info",
          cond = function(client) return client.name == "clangd" end,
        },
      },
      i = {

        ["<C-k>"] = {
          function() vim.lsp.buf.signature_help() end,
          desc = "Signature help",
          cond = "textDocument/signatureHelp",
        },
        ["<A-Space>"] = {
          function()
            -- Simply exit insert mode, same as Esc
            vim.cmd "stopinsert"
          end,
          desc = "Exit insert mode (same as Esc)",
        },
      },
    }, -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}
