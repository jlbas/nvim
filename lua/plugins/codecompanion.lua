return {
  'olimorris/codecompanion.nvim',
  opts = {
    display = {
      action_palette = {
        provider = 'snacks',
      },
      chat = {
        window = {
          width = "auto",
        },
      },
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    {
      'github/copilot.vim',
      config = function()
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true
      end,
    }
  },
  enabled = IS_WORK,
}
