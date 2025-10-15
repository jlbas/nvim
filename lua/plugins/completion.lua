vim.pack.add({
  'https://github.com/rafamadriz/friendly-snippets',
  {
    src = 'https://github.com/saghen/blink.cmp',
    version = vim.version.range('1.*'),
  },
})

require('blink.cmp').setup({
  appearance = {
    use_nvim_cmp_as_default = true,
  },
  keymap = {
    preset = 'default',
    ['<C-n>'] = {
      function(cmp)
        if cmp.is_visible() then
          cmp.select_next()
        else
          cmp.show()
        end
      end
    },
    ['<C-p>'] = {
      function(cmp)
        if cmp.is_visible() then
          cmp.select_prev()
        else
          cmp.show()
        end
      end
    },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    per_filetype = {
      codecompanion = { 'codecompanion' },
    },
  },
})
