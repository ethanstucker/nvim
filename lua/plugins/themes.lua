return {
  -- First, add the Everforest theme plugin itself
  {
    "sainnhe/everforest",
    priority = 1000, -- Make sure it loads first
    config = function()
      vim.g.everforest_background = "medium"
--      vim.cmd.colorscheme("everforest")
    end,
  },

  -- Second, tell LazyVim to use "everforest" as the default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
--      colorscheme = "everforest",
    },
  },
}
