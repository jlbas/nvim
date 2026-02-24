vim.pack.add({'https://github.com/ibhagwan/fzf-lua'})

require('fzf-lua').setup({
  'default-title',
  defaults = {
    formatter = 'path.filename_first',
    cwd_prompt = true,
  },
  winopts = {
    border = 'none',
    backdrop = 60,
    treesitter = { enabled = true },
    preview = {
      border = 'none',
      layout = 'flex',
      scrollbar = 'float',
    },
  },
  fzf_opts = {
    ['--cycle'] = true,
    ['--keep-right'] = true,
  },
  files = {
    line_query = true,
  },
  keymap = {
    builtin = {
      ['<C-f>'] = 'preview-page-down',
      ['<C-b>'] = 'preview-page-up',
      ['<C-d>'] = 'preview-half-page-down',
      ['<C-u>'] = 'preview-half-page-up',
    },
    fzf = {
      ['ctrl-q'] = 'select-all+accept',
      ['ctrl-f'] = 'preview-page-down',
      ['ctrl-b'] = 'preview-page-up',
      ['ctrl-d'] = 'preview-half-page-down',
      ['ctrl-u'] = 'preview-half-page-up',
    },
  },
  grep = {
    rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g "!customlog*" -e',
  },
})
