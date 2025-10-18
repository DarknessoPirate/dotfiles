return {
  {
    "CRAG666/code_runner.nvim",
    cmd = { "RunCode", "RunFile", "RunProject", "RunClose" },
    keys = {
      { "<leader>rr", ":RunCode<CR>", desc = "Run Code" },
      { "<leader>rf", ":RunFile<CR>", desc = "Run File" },
      { "<leader>rp", ":RunProject<CR>", desc = "Run Project" },
      { "<leader>rc", ":RunClose<CR>", desc = "Close Runner" },
    },
    opts = {
      mode = "term",
      focus = false,
      startinsert = true,
      filetype = {
        -- C# using native Neovim UI with clean structure
        cs = function(...)
          local root_dir = require("lspconfig").util.root_pattern "*.csproj"(vim.loop.cwd())

          if not root_dir then
            vim.notify("No .csproj file found", vim.log.levels.ERROR)
            return
          end

          -- Clean table structure like before
          local cs_commands = {
            {
              name = "Run Project",
              command = "cd " .. root_dir .. " && dotnet run",
            },
            {
              name = "Build Project",
              command = "cd " .. root_dir .. " && dotnet build",
            },
            {
              name = "Restore Packages",
              command = "cd " .. root_dir .. " && dotnet restore",
            },
            {
              name = "Clean Project",
              command = "cd " .. root_dir .. " && dotnet clean",
            },
            {
              name = "Add Migration",
              input_required = true,
              prompt = "Migration name:",
              command_template = "cd " .. root_dir .. " && dotnet ef migrations add %s",
            },
            {
              name = "Update Database",
              command = "cd " .. root_dir .. " && dotnet ef database update",
            },
            {
              name = "Remove Last Migration",
              command = "cd " .. root_dir .. " && dotnet ef migrations remove",
            },
            {
              name = "Add Package",
              input_required = true,
              prompt = "Package name:",
              command_template = "cd " .. root_dir .. " && dotnet add package %s",
            },
            {
              name = "Run Tests",
              command = "cd " .. root_dir .. " && dotnet test",
            },
            {
              name = "Watch Run",
              command = "cd " .. root_dir .. " && dotnet watch run",
            },
          }

          -- Extract just the names for vim.ui.select
          local options = {}
          for _, item in ipairs(cs_commands) do
            table.insert(options, item.name)
          end

          -- Use native Neovim UI
          vim.ui.select(options, {
            prompt = "Select C# command:",
            format_item = function(item) return "🔷 " .. item end,
          }, function(choice)
            if not choice then return end

            -- Find the selected command using ipairs (clean!)
            for _, item in ipairs(cs_commands) do
              if item.name == choice then
                if item.input_required then
                  vim.ui.input({ prompt = item.prompt }, function(input)
                    if input and input ~= "" then
                      local command = string.format(item.command_template, input)
                      require("code_runner.commands").run_from_fn { command }
                    end
                  end)
                else
                  if type(item.command) == "table" then
                    require("code_runner.commands").run_from_fn(item.command)
                  else
                    require("code_runner.commands").run_from_fn { item.command }
                  end
                end
                break
              end
            end
          end)
        end,

        -- C++ using native Neovim UI with clean structure
        cpp = function(...)
          local cpp_commands = {
            {
              name = "Simple g++",
              command = "cd $dir && g++ -std=c++17 $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
            },
            {
              name = "Advanced g++",
              command = {
                "cd $dir &&",
                "g++ -std=c++17 -Wall -Wextra -g -O2 $fileName -o $fileNameWithoutExt &&",
                "./$fileNameWithoutExt",
              },
            },
            {
              name = "CMake Debug",
              command = {
                "cd $dir/.. &&",
                "mkdir -p build &&",
                "cmake -B build -DCMAKE_BUILD_TYPE=Debug &&",
                "cmake --build build &&",
                "./bin/debug/the_project_name", -- ADD THIS LINE!
              },
            },
            {
              name = "CMake Release",
              command = {
                "cd $dir/.. &&",
                "mkdir -p build &&",
                "cmake -B build -DCMAKE_BUILD_TYPE=Release &&",
                "cmake --build build &&",
                "./bin/release/the_project_name", -- ADD THIS LINE!
              },
            },
            {
              name = "CMake Clean Build",
              command = {
                "cd $dir/.. &&",
                "rm -rf build &&",
                "mkdir -p build &&",
                "cmake -B build -DCMAKE_BUILD_TYPE=Debug &&",
                "cmake --build build &&",
                "./bin/debug/the_project_name", -- ADD THIS LINE!
              },
            },
          }

          -- Extract names for selection
          local options = {}
          for _, item in ipairs(cpp_commands) do
            table.insert(options, item.name)
          end

          vim.ui.select(options, {
            prompt = "Select C++ build method:",
            format_item = function(item) return "" .. item end,
          }, function(choice)
            if not choice then return end

            -- Find and execute the selected command (clean!)
            for _, item in ipairs(cpp_commands) do
              if item.name == choice then
                if type(item.command) == "table" then
                  require("code_runner.commands").run_from_fn(item.command)
                else
                  require("code_runner.commands").run_from_fn { item.command }
                end
                break
              end
            end
          end)
        end,

        -- Other languages (simple)
        java = {
          "cd $dir &&",
          "javac $fileName &&",
          "java $fileNameWithoutExt",
        },
        python = "python3 -u",
        javascript = "node",
        lua = "lua",
      },
    },
    config = function(_, opts) require("code_runner").setup(opts) end,
  },
}
