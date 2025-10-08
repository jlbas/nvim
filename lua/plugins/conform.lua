vim.pack.add({'https://github.com/stevearc/conform.nvim'})

local conform = require('conform')

conform.setup({
  formatters_by_ft = {
    c = { 'clang_format' },
    cpp = { 'clang_format' },
    lua = { 'stylua' },
    markdown = { 'prettier' },
    python = { 'isort', 'black' },
  },
})

conform.formatters.black = {
  prepend_args = { '--line-length', '120' }
}

conform.formatters.clang_format = {
  prepend_args = { '-style', 'file:' .. vim.fn.expand("$HOME/.config/clangd/clang-format.yaml") },
}
