return {
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      require('mini.ai').setup()
      require('mini.align').setup()
      -- require('mini.base16').setup()
      require('mini.comment').setup()
      require('mini.completion').setup()
      require('mini.extra').setup()
      require('mini.files').setup()
      require('mini.hipatterns').setup({
        highlighters = {
          todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
          note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },
          hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
        },
      })
      require('mini.pairs').setup({
        mappings = {
          [' '] = { action = 'open', pair = '  ', neigh_pattern = '[%(%[{][%)%]}]' },
        },
      })
      require('mini.pick').setup({
        options = {
          content_from_bottom = true,
        },
        window = {
          config = function()
            local height = math.floor(0.314 * vim.o.lines)
            local width = math.floor(0.618 * vim.o.columns)
            return {
              anchor = 'NW', height = height, width = width,
              row = math.floor(0.5 * (vim.o.lines - height)),
              col = math.floor(0.5 * (vim.o.columns - width)),
            }
          end,
        },
      })
      require('mini.splitjoin').setup({
        mappings = {
          toggle = 'gs'
        }
      })
      require('mini.surround').setup()
    end,
  },
}
