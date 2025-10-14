-- ~/.config/nvim/lua/plugins/auto-clang-format.lua
return {
  -- This is a self-contained configuration, so no external plugin is needed.
  -- The 'event' key ensures this code runs after Neovim has started up.
  event = "VeryLazy",
  config = function()
    -- The content that will be written to the new .clang-format file
    local clang_format_content = [[
# .clang-format
---
# Based on Google's style, but with tabs instead of spaces
BasedOnStyle: Google
# Use real tab characters for indentation
UseTab: Always
# Set the width of an indentation level
IndentWidth: 4
# Set the column width for a tab character
TabWidth: 4
AlignConsecutiveAssignments: false
AlignConsecutiveDeclarations: false
]]

    -- Create a dedicated autocommand group to keep things clean
    local augroup = vim.api.nvim_create_augroup("AutoClangFormat", { clear = true })
    -- A table to track which project roots we've already checked in this session
    local checked_roots = {}

    vim.api.nvim_create_autocmd("BufEnter", {
      group = augroup,
      -- Only run this for C, C++, and Java files
      pattern = { "*.cpp", "*.c", "*.h", "*.hpp", "*.java" },
      callback = function(args)
        local current_file_path = vim.api.nvim_buf_get_name(args.buf)
        -- Ignore temporary or unnamed buffers
        if current_file_path == "" or vim.fn.filereadable(current_file_path) == 0 then
          return
        end

        local current_dir = vim.fn.fnamemodify(current_file_path, ":h")

        -- Find the project root by searching upwards for a .git directory
        local root_markers = { ".git" }
        local root_path = vim.fs.find(root_markers, { path = current_dir, upward = true, type = "directory" })[1]

        -- If a .git folder was found, its parent is the project root
        local root = root_path and vim.fn.fnamemodify(root_path, ":h")

        if not root then
          return -- Not inside a git project, so do nothing
        end

        -- If we have already checked this root directory, don't ask again
        if checked_roots[root] then
          return
        end

        -- Mark this root as checked for the current session
        checked_roots[root] = true

        local clang_format_path = root .. "/.clang-format"

        -- Check if .clang-format already exists (filereadable returns 0 for false)
        if vim.fn.filereadable(clang_format_path) == 0 then
          -- Ask the user for confirmation before creating the file
          vim.ui.confirm("No .clang-format found. Create one with tab settings?", {
            { text = "Yes", value = true },
            { text = "No", value = false },
          }, function(confirmed)
            if confirmed then
              -- Use vim.fn.writefile to create the file with the specified content
              local success = vim.fn.writefile(vim.split(clang_format_content, "\n"), clang_format_path)
              if success == 0 then
                vim.notify("Created .clang-format in " .. root, vim.log.levels.INFO, { title = "Auto-Format" })
              else
                vim.notify("Error: Failed to create .clang-format file.", vim.log.levels.ERROR, { title = "Auto-Format" })
              end
            end
          end)
        end
      end,
    })
  end,
}

