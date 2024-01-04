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
          component_separators = '│',
          section_separators = '',
        },
        winbar = {
          lualine_c = {
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
