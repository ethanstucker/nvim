return {
  "neovim/nvim-lspconfig",
  -- This is an event that triggers the configuration
  event = "LazyFile",
  config = function()
    -- Create a dedicated autocommand group to keep things clean
    local diagnostics_group = vim.api.nvim_create_augroup("java_diagnostics_control", { clear = true })

    vim.api.nvim_create_autocmd({ "InsertEnter" }, {
      group = diagnostics_group,
      pattern = "*.java", -- Only applies to Java files
      callback = function()
        -- When you start typing, turn off diagnostics
        vim.diagnostic.disable()
      end,
    })

    vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
      group = diagnostics_group,
      pattern = "*.java", -- Only applies to Java files
      callback = function()
        -- When you stop typing or save the file, turn diagnostics back on
        vim.diagnostic.enable()
      end,
    })
  end,
}
