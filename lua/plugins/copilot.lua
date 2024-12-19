return {
  {
    'zbirenbaum/copilot.lua',
    build = ':Copilot auth',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup({
        suggestions = {
          enabled = false,
        },
        panel = {
          auto_refresh = true,
          enabled = false,
          keymap = {
            jump_next = '<C-l>',
            jump_prev = '<C-h>',
          }
        },
      })
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim' },
    },
    build = 'make tiktoken',
    opts = {},
  }
}
