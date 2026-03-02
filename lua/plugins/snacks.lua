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
  },
})
