return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- Make hidden files visible by default
        hide_dotfiles = false,
        hide_gitignored = false,
        show_hidden_count = true, -- Show count of hidden files in folders
        hide_by_name = {
          -- Optionally hide specific files/folders by name
          -- ".git",
          -- ".DS_Store",
          -- "thumbs.db",
        },
        never_show = {
          -- Files that should NEVER be shown
          -- ".DS_Store",
          -- "thumbs.db",
        },
      },
      -- Optional: Follow current file
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      -- Optional: Use libuv file watcher for better performance
      use_libuv_file_watcher = true,
    },
  },
}
