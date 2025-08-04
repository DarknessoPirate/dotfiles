return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      mappings = {
        ["<C-x>"] = {
          function(state)
            local node = state.tree:get_node()
            if node.type == "file" then
              local filepath = node:get_id()
              -- Cross-platform executable runner
              vim.fn.jobstart(filepath, { detach = true })
            end
          end,
          desc = "Execute file",
        },
        ["<C-t>"] = {
          function(state)
            local node = state.tree:get_node()
            if node.type == "file" then
              local filepath = node:get_id()
              -- Move to the main editing area first
              vim.cmd "wincmd l"
              -- Open terminal at the bottom
              vim.cmd "botright split"
              vim.cmd("terminal " .. vim.fn.shellescape(filepath))
              vim.cmd "resize 15"
            end
          end,
          desc = "Run in terminal",
        },
        ["u"] = "navigate_up",
      },
    },

    filesystem = {
      bind_to_cwd = false,
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
