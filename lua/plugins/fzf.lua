vim.pack.add({'https://github.com/ibhagwan/fzf-lua'})

local function pick_win_action(selected, opts)
  local utils = require('config.utils')
  local win = utils.pick_win()
  if win then
    vim.api.nvim_set_current_win(win)
    require('fzf-lua.actions').file_edit(selected, opts)
  end
end

require('fzf-lua').setup({
  'default-title',
  defaults = {
    formatter = 'path.filename_first',
    cwd_prompt = true,
  },
  actions = {
    files = {
      true,
      ['ctrl-o'] = pick_win_action,
    },
  },
  winopts = {
    border = 'none',
    backdrop = 60,
    treesitter = { enabled = true },
    preview = {
      border = 'none',
      layout = 'flex',
      horizontal = 'right:50%',
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
