-- ~/.config/nvim/lua/user/plugins/nvim-lint.lua
-- or ~/.config/nvim/lua/plugins/nvim-lint.lua (depending on your AstroNvim setup)

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require "lint"

    -- Configure linters by filetype
    lint.linters_by_ft = {
      glsl = { "glslangValidator" },
      vert = { "glslangValidator" },
      frag = { "glslangValidator" },
      geom = { "glslangValidator" },
      comp = { "glslangValidator" },
      tesc = { "glslangValidator" },
      tese = { "glslangValidator" },
    }

    -- Configure the glslangValidator linter
    lint.linters.glslangValidator = {
      cmd = "glslangValidator",
      stdin = false, -- Use file instead of stdin
      args = {},
      stream = "stdout",
      ignore_exitcode = true,
      parser = function(output, bufnr)
        local diagnostics = {}

        for line in output:gmatch "[^\r\n]+" do
          -- Skip summary lines like "ERROR: 2 compilation errors..."
          if not line:match "ERROR: %d+ compilation errors" then
            -- Parse ERROR messages
            -- Format: "ERROR: 0:10: 'projon' : undeclared identifier"
            local lnum, message = line:match "ERROR: %d+:(%d+): (.*)"

            if lnum and message then
              -- Skip empty or generic messages
              if message ~= "" and not message:match "^%s*$" and not message:match "compilation terminated" then
                table.insert(diagnostics, {
                  lnum = tonumber(lnum) - 1, -- Convert to 0-based indexing
                  col = 0,
                  message = message,
                  severity = vim.diagnostic.severity.ERROR,
                  source = "glslangValidator",
                })
              end
            end

            -- Parse WARNING messages
            local lnum, message = line:match "WARNING: %d+:(%d+): (.*)"

            if lnum and message then
              -- Skip empty or generic messages
              if message ~= "" and not message:match "^%s*$" then
                table.insert(diagnostics, {
                  lnum = tonumber(lnum) - 1,
                  col = 0,
                  message = message,
                  severity = vim.diagnostic.severity.WARN,
                  source = "glslangValidator",
                })
              end
            end
          end
        end

        return diagnostics
      end,
    }

    -- Set up autocommands for automatic linting
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      pattern = { "*.glsl", "*.vert", "*.frag", "*.geom", "*.comp", "*.tesc", "*.tese" },
      callback = function()
        -- Only lint if glslangValidator is available
        if vim.fn.executable "glslangValidator" == 1 then
          lint.try_lint()
        else
          vim.notify("glslangValidator not found. Install with: sudo dnf install glslang", vim.log.levels.WARN)
        end
      end,
    })

    -- Set up GLSL filetype detection
    vim.filetype.add {
      extension = {
        vert = "glsl",
        frag = "glsl",
        geom = "glsl",
        comp = "glsl",
        tesc = "glsl",
        tese = "glsl",
        glsl = "glsl",
      },
    }
  end,
}
