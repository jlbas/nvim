vim.pack.add({
  'https://github.com/SmiteshP/nvim-navic',
  'https://github.com/nvim-lualine/lualine.nvim',
})

local navic = require('nvim-navic')
navic.setup({
  lsp = {
    auto_attach = true,
    preference = {
      "clangd",
      "protols",
    },
  },
})

local function scrollbind_status()
  return vim.wo.scrollbind and '⇵ ' or ''
end

local function vertical_centering_status()
  return vim.o.scrolloff == 999 and '↕' or ''
end

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
    lualine_x = {
      {
        scrollbind_status,
      },
      {
        vertical_centering_status,
      },
    }
  }
})
