return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = {},
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
      picker = {},
    },
  },
}
