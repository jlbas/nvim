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
      cwd_bonus = true,
      frecency = true,
      history_bonus = true,
    },
    previewers = {
      file = {
        max_size = 10 * 1024 * 1024,
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
    layouts = {
      default = {
        layout = {
          box = "horizontal",
          width = 0.8,
          min_width = 120,
          height = 0.8,
          {
            box = "vertical",
            border = 'single',
            title = "{title} {live} {flags}",
            { win = "input", height = 1, border = "bottom" },
            { win = "list", border = "none" },
          },
          { win = "preview", title = "{preview}", border = 'single', width = 0.5 },
        },
      },
      select = {
        hidden = { "preview" },
        layout = {
          backdrop = false,
          width = 0.5,
          min_width = 80,
          height = 0.4,
          min_height = 3,
          box = "vertical",
          border = 'single',
          title = "{title}",
          title_pos = "center",
          { win = "input", height = 1, border = "bottom" },
          { win = "list", border = "none" },
          { win = "preview", title = "{preview}", height = 0.4, border = "top" },
        },
      },
      sidebar = {
        preview = "main",
        layout = {
          backdrop = false,
          width = 40,
          min_width = 40,
          height = 0,
          position = "left",
          border = "none",
          box = "vertical",
          {
            win = "input",
            height = 1,
            border = 'single',
            title = "{title} {live} {flags}",
            title_pos = "center",
          },
          { win = "list", border = "none" },
          { win = "preview", title = "{preview}", height = 0.4, border = "top" },
        },
      },
      vertical = {
        layout = {
          backdrop = false,
          width = 0.5,
          min_width = 80,
          height = 0.8,
          min_height = 30,
          box = "vertical",
          border = 'single',
          title = "{title} {live} {flags}",
          title_pos = "center",
          { win = "input", height = 1, border = "bottom" },
          { win = "list", border = "none" },
          { win = "preview", title = "{preview}", height = 0.4, border = "top" },
        },
      },
      vscode = {
        hidden = { "preview" },
        layout = {
          backdrop = false,
          row = 1,
          width = 0.4,
          min_width = 80,
          height = 0.4,
          border = "none",
          box = "vertical",
          { win = "input", height = 1, border = 'single', title = "{title} {live} {flags}", title_pos = "center" },
          { win = "list", border = "hpad" },
          { win = "preview", title = "{preview}", border = 'single' },
        },
      },
    },
  },
})
