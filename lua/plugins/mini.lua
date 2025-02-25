return {
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      -- require('mini.ai').setup()
      -- require('mini.align').setup()
      -- require('mini.base16').setup()
      -- require('mini.comment').setup()
      -- require('mini.cursorword').setup()
      require('mini.extra').setup()
      require('mini.icons').setup()
      require('mini.hipatterns').setup({
        highlighters = {
          do_not_commit = { pattern = '%f[%w]()DO_NOT_COMMIT()%f[%W]', group = '@comment.error' },
          do_not_push = { pattern = '%f[%w]()DO_NOT_PUSH()%f[%W]', group = '@comment.error' },
          note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },
          todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
          hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
        },
      })
      require('mini.trailspace').setup()
      -- require('mini.indentscope').setup({
      --   draw = {
      --     animation = require('mini.indentscope').gen_animation.none(),
      --   },
      --   symbol = '│',
      -- })
      -- require('mini.pairs').setup({
      --   mappings = {
      --     [' '] = { action = 'open', pair = '  ', neigh_pattern = '[%(%[{][%)%]}]' },
      --   },
      -- })
      -- require('mini.pick').setup({
      --   options = {
      --     content_from_bottom = true,
      --   },
      --   mappings = {
      --     choose_in_split = '<C-x>',
      --     mark = '<C-m>',
      --     choose_marked = '<C-CR>',
      --   },
      --   source = {
      --     choose_marked = function(items)
      --       for _, item in ipairs(items) do
      --         vim.cmd.badd(item)
      --       end
      --     end,
      --   },
      --   window = {
      --     config = function()
      --       local height = math.floor(0.314 * vim.o.lines)
      --       local width = math.floor(0.618 * vim.o.columns)
      --       return {
      --         anchor = 'NW', height = height, width = width,
      --         row = math.floor(0.5 * (vim.o.lines - height)),
      --         col = math.floor(0.5 * (vim.o.columns - width)),
      --       }
      --     end,
      --   },
      -- })
      -- require('mini.splitjoin').setup({
      --   mappings = {
      --     toggle = 'gs'
      --   }
      -- })
      -- require('mini.surround').setup() -- using nvim-surround instead
      -- require('mini.visits').setup()
      --
      -- local map_vis = function(keys, call, desc)
      --   local rhs = '<Cmd>lua MiniVisits.' .. call .. '<CR>'
      --   vim.keymap.set('n', '<Leader>' .. keys, rhs, { desc = desc })
      -- end
      -- map_vis('vv', 'add_label()',          'Add label')
      -- map_vis('vV', 'remove_label()',       'Remove label')
      -- map_vis('vl', 'select_label("", "")', 'Select label (all)')
      -- map_vis('vL', 'select_label()',       'Select label (cwd)')

      local function mini_enable(module, fts)
        for _, ft in ipairs(fts) do
          if vim.bo.filetype == ft then
            return
          end
        end
        vim.b[module .. '_disable'] = true
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          mini_enable('miniindentscope', { 'c', 'cpp', 'lua', 'python' })
          mini_enable('minicursorword', { 'c', 'cpp', 'lua', 'python', 'text' })
        end
      })

      vim.api.nvim_create_autocmd("TermOpen", {
        callback = function(args)
          vim.b[args.buf].miniindentscope_disable = true
        end
      })

    end,
  },
}
