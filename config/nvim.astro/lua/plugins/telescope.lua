-- ~/.config/nvim/lua/plugins/telescope.lua
-- Telescope configuration for AstroVim with proper keybind integration

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function() return vim.fn.executable "make" == 1 end,
    },
  },
  cmd = "Telescope",
  opts = function()
    local actions = require "telescope.actions"

    return {
      defaults = {
        prompt_prefix = "  ",
        selection_caret = " ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = { "truncate" },
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        use_less = true,
        set_env = { ["COLORTERM"] = "truecolor" },
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-c>"] = actions.close,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-l>"] = actions.complete_tag,
            ["<C-_>"] = actions.which_key,
          },
          n = {
            ["<esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["?"] = actions.which_key,
          },
        },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
          previewer = false,
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
        git_files = {
          theme = "dropdown",
          previewer = false,
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
          initial_mode = "normal",
          mappings = {
            i = {
              ["<C-d>"] = actions.delete_buffer,
            },
            n = {
              ["dd"] = actions.delete_buffer,
            },
          },
        },
        planets = {
          show_pluto = true,
          show_moon = true,
        },
        colorscheme = {
          enable_preview = true,
        },
        lsp_references = {
          theme = "dropdown",
          initial_mode = "normal",
        },
        lsp_definitions = {
          theme = "dropdown",
          initial_mode = "normal",
        },
        lsp_declarations = {
          theme = "dropdown",
          initial_mode = "normal",
        },
        lsp_implementations = {
          theme = "dropdown",
          initial_mode = "normal",
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    }
  end,
  config = function(_, opts)
    local telescope = require "telescope"
    telescope.setup(opts)

    -- Load extensions
    if vim.fn.executable "make" == 1 then pcall(telescope.load_extension, "fzf") end
  end,
  specs = {
    -- Override/extend AstroVim's existing keybinds
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings

        -- Add custom telescope keybinds that don't conflict
        maps.n["<leader>f"] = { name = " Find" }

        -- Override some existing ones or add new ones
        maps.n["<leader>fF"] = { "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", desc = "Find all files" }
        maps.n["<leader>fW"] = { "<cmd>Telescope grep_string<cr>", desc = "Find word under cursor" }
        maps.n["<leader>fr"] = { "<cmd>Telescope resume<cr>", desc = "Resume last search" }
        maps.n["<leader>fp"] = { "<cmd>Telescope pickers<cr>", desc = "Previous searches" }
        maps.n["<leader>f/"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in current buffer" }

        -- Add new telescope pickers under a different prefix
        maps.n["<leader>T"] = { name = "🔭 Telescope" }
        maps.n["<leader>Tf"] = { "<cmd>Telescope find_files<cr>", desc = "Find files" }
        maps.n["<leader>Tg"] = { "<cmd>Telescope live_grep<cr>", desc = "Live grep" }
        maps.n["<leader>Tb"] = { "<cmd>Telescope buffers<cr>", desc = "Buffers" }
        maps.n["<leader>Th"] = { "<cmd>Telescope help_tags<cr>", desc = "Help tags" }
        maps.n["<leader>Tm"] = { "<cmd>Telescope marks<cr>", desc = "Marks" }
        maps.n["<leader>To"] = { "<cmd>Telescope oldfiles<cr>", desc = "Recent files" }
        maps.n["<leader>Tc"] = { "<cmd>Telescope commands<cr>", desc = "Commands" }
        maps.n["<leader>Tk"] = { "<cmd>Telescope keymaps<cr>", desc = "Keymaps" }
        maps.n["<leader>Ts"] = { "<cmd>Telescope symbols<cr>", desc = "Symbols" }
        maps.n["<leader>Tt"] = { "<cmd>Telescope colorscheme<cr>", desc = "Themes" }
        maps.n["<leader>Tr"] = { "<cmd>Telescope registers<cr>", desc = "Registers" }
        maps.n["<leader>Td"] = { "<cmd>Telescope lsp_references<cr>", desc = "References (Telescope)" }

        maps.n["<leader>Td"] = { "<cmd>Telescope lsp_references<cr>", desc = "References (Telescope)" }
        maps.n["<leader>TD"] = { "<cmd>Telescope lsp_definitions<cr>", desc = "Definitions (Telescope)" }
        maps.n["<leader>TI"] = { "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations (Telescope)" }
        maps.n["<leader>TT"] = { "<cmd>Telescope lsp_type_definitions<cr>", desc = "Type definitions (Telescope)" }
        maps.n["<leader>TS"] = { "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols (Telescope)" }
        maps.n["<leader>TW"] = { "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols (Telescope)" }
        return opts
      end,
    },
  },
}
