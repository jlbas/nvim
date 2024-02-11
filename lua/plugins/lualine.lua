return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'SmiteshP/nvim-navic',
      opts = {
        lsp = { auto_attach = true }
      }
    },
    config = function()
      local navic = require('nvim-navic')
      require('lualine').setup({
        options = {
          globalstatus = true,
          -- component_separators = '│',
          component_separators = '',
          section_separators = '',
        },
        sections = {
          lualine_b = {
            { 'branch', 'diff' },
          },
          lualine_c = {
            { 'diagnostics' },
            {
              'filename',
              path = 1,
            },
            {
              function()
                return navic.get_location()
              end,
              cond = function()
                return navic.is_available()
              end
            },
          },
        }
      })
    end
  },
}
