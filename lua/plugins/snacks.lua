vim.pack.add({'https://github.com/folke/snacks.nvim'})

require('snacks').setup({
  bigfile = {
    notify = false,
  },
  bufdelete = {},
  indent = {
    indent = {
      only_scope = true,
      only_current = true,
    },
    animate = { enabled = false },
    filter = function (buf)
      return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == "" and
        not vim.tbl_contains({'help', 'markdown'}, vim.bo[buf].filetype)
    end,
  },
  picker = {
    sources = {
      explorer = {
        replace_netrw = true,
        auto_close = true,
      },
    },
    matcher = {
      frecency = true,
    },
    previewers = {
      file = {
        max_size = 10 * 1024 * 1024,
      },
    },
    layout = {
      layout = {
        box = "vertical",
        row = -1,
        width = 0,
        height = 0.4,
        border = "none",
        title = " {title} {live} {flags}",
        title_pos = "left",
        { win = "input", height = 1, border = "none" },
        {
          box = "horizontal",
          { win = "list", border = "none" },
          { win = "preview", title = "{preview}", width = 0.6, border = "none" },
        },
      },
    },
    win = {
      input = {
        keys = {
          ['<C-,>'] = { { 'pick_win', 'jump' }, mode = { 'n', 'i' } },
          ['<C-t>'] = { 'edit_tab', mode = { 'n', 'i' } },
          ['<C-l>'] = { 'focus_preview', mode = { 'n', 'i' } },
        },
      },
      list = {
        keys = {
          ['<C-,>'] = { { 'pick_win', 'jump' }, mode = { 'n', 'i' } },
          ['<C-t>'] = { 'edit_tab', mode = { 'n', 'i' } },
          ['<C-l>'] = { 'focus_preview', mode = { 'n', 'i' } },
        },
      },
      preview = {
        keys = {
          ['<C-l>'] = { 'focus_input', mode = { 'n', 'i' } },
        },
      },
    },
  },
})
