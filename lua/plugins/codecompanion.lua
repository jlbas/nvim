if IS_WORK then
  vim.pack.add({
    'https://github.com/olimorris/codecompanion.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/github/copilot.vim',
  })

  vim.g.copilot_assume_mapped = true
  vim.g.copilot_enabled = false
  vim.g.copilot_no_tab_map = true

  require('codecompanion').setup({
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
  })
end
