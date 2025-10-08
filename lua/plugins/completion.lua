vim.pack.add({
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/saghen/blink.cmp',
})

require('blink.cmp').setup({
  keymap = {
    preset = 'default',
  },
  appearance = {
    use_nvim_cmp_as_default = true,
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    per_filetype = {
      codecompanion = { 'codecompanion' },
    },
  },
  -- signature = { enabled = true }
})
