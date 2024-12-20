return {
  'stevearc/oil.nvim',
  opts = {
    keymaps = {
      ["<C-v>"] = { "actions.select", opts = { vertical = true } },
      ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
      ["<C-f>"] = { "actions.preview_scroll_down" },
      ["<C-b>"] = { "actions.preview_scroll_up" },
    },
    view_options = {
      show_hidden = true,
    },
  },
}
