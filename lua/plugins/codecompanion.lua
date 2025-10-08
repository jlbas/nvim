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
    -- { 'zbirenbaum/copilot.lua',
    --   build = ':Copilot auth',
    --   cmd = 'Copilot',
    --   event = 'InsertEnter',
    --   config = function()
    --     require('copilot').setup({
    --       -- suggestions = {
    --       --   enabled = true,
    --       -- },
    --       -- panel = {
    --       --   auto_refresh = true,
    --       --   enabled = false,
    --       --   keymap = {
    --       --     jump_next = '<C-l>',
    --       --     jump_prev = '<C-h>',
    --       --   }
    --       -- },
    --     })
    --   end,
    -- },
  },
}
