---@type LazySpec
return {
  -- AstroCommunity colorschemes
  { import = "astrocommunity.colorscheme.catppuccin" },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      transparent_background = true,
      show_end_of_buffer = true,
    },
  },
  { import = "astrocommunity.colorscheme.horizon-nvim" },
  { import = "astrocommunity.colorscheme.iceberg-vim" },
  { import = "astrocommunity.colorscheme.kanagawa-nvim" },
  { import = "astrocommunity.colorscheme.github-nvim-theme" },
  { import = "astrocommunity.colorscheme.everblush-nvim" },
  { import = "astrocommunity.colorscheme.tokyonight-nvim" },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  { import = "astrocommunity.colorscheme.sonokai" },
  { import = "astrocommunity.colorscheme.rose-pine" },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      styles = {
        transparency = true,
      },
    },
  },
  { import = "astrocommunity.colorscheme.oxocarbon-nvim" },
  { import = "astrocommunity.colorscheme.onedarkpro-nvim" },
  { import = "astrocommunity.colorscheme.nordic-nvim" },
  { import = "astrocommunity.colorscheme.nord-nvim" },
  { import = "astrocommunity.colorscheme.nightfox-nvim" },

  -- Manual theme installations with configurations
  {
    "AstroNvim/astrotheme",
    opts = {
      palette = "astrodark",
      background = {
        transparent = true,
      },
      highlights = {
        global = {
          Normal = { bg = "NONE" },
          NormalNC = { bg = "NONE" },
          SignColumn = { bg = "NONE" },
          NormalFloat = { bg = "NONE" },
          FloatBorder = { bg = "NONE" },

          NeoTreeNormal = { bg = "NONE" },
          NeoTreeNormalNC = { bg = "NONE" },
          NeoTreeEndOfBuffer = { bg = "NONE" },
          NeoTreeWinSeparator = { bg = "NONE" },
        },
      },
    },
  },

  {
    "tiagovla/tokyodark.nvim",
    name = "tokyodark",
    priority = 1000,
    opts = {
      transparent_background = true, -- Set to true for transparent background
      gamma = 1.00, -- Adjust the brightness of the theme
      styles = {
        comments = { italic = true }, -- Style for comments
        keywords = { italic = true }, -- Style for keywords
        identifiers = { italic = true }, -- Style for identifiers
        functions = {}, -- Style for functions
        variables = {}, -- Style for variables
      },
      custom_highlights = {}, -- Extend highlights
      custom_palette = {}, -- Extend palette
      terminal_colors = true, -- Enable terminal colors
    },
  },

  {
    "wadackel/vim-dogrun",
    name = "dogrun",
    priority = 1000,
    config = function()
      -- vim.g.dogrun_transparent = 0
    end,
  },

  {
    "olivercederborg/poimandres.nvim",
    name = "poimandres",
    priority = 1000,
    opts = {
      bold_vert_split = false,
      dim_nc_background = false,
      disable_background = false,
      disable_float_background = false,
      disable_italics = false,
    },
  },

  {
    "wilmanbarrios/palenight.nvim",
    name = "palenight",
    priority = 1000,
    -- Removed auto-colorscheme setting to avoid conflicts
  },

  {
    "diegoulloao/neofusion.nvim",
    name = "neofusion",
    priority = 1000,
    opts = {
      terminal_colors = true,
      transparent_mode = false,
    },
  },
}
