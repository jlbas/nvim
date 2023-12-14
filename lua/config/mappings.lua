local default_opts = { noremap = true, silent = true }
local keymap = function(mode, keys, cmd, desc, opts)
  opts = vim.tbl_deep_extend('force', default_opts, opts or {})
  opts.desc = desc
  vim.keymap.set(mode, keys, cmd, opts)
end

-- System clipboard ------------------------------------------------------------
keymap({'n', 'x'}, '<leader>cy', '"+y', 'Copy to system clipboard')
-- keymap({'n', 'x'}, '<leader>cp', '"+p', 'Paste from system clipboard') -- not supported in Wezterm

-- Search ----------------------------------------------------------------------
keymap('n', '<leader>i', ':let v:hlsearch = 1 - v:hlsearch<CR>', 'Toggle hlsearch')
keymap('x', '/', '<esc>/\\%V', 'Search inside visual selection', { silent = false  })

-- Window navigation -----------------------------------------------------------
keymap('n', '<C-h>', '<C-w>h', 'Focus on left window' )
keymap('n', '<C-j>', '<C-w>j', 'Focus on below window')
keymap('n', '<C-k>', '<C-w>k', 'Focus on above window')
keymap('n', '<C-l>', '<C-w>l', 'Focus on right window')

-- Window resizing -------------------------------------------------------------
keymap('n', '<M-h>', '"<cmd>vertical resize -" . v:count1 . "<CR>"', 'Decrease window width', { expr = true, replace_keycodes = false })
keymap('n', '<M-j>', '"<cmd>resize -" . v:count1 . "<CR>"', 'Decrease window height', { expr = true, replace_keycodes = false })
keymap('n', '<M-k>', '"<cmd>resize +" . v:count1 . "<CR>"', 'Increase window height', { expr = true, replace_keycodes = false })
keymap('n', '<M-l>', '"<cmd>vertical resize +" . v:count1 . "<CR>"', 'Increase window width', { expr = true, replace_keycodes = false })
keymap('n', '<M-=>', '<C-w>=', 'Make windows equally sized')

-- Move with alt ---------------------------------------------------------------
keymap('c', '<M-h>', '<left>', 'Left', { silent = false })
keymap('c', '<M-l>', '<right>', 'Right', { silent = false })
keymap('i', '<M-h>', '<left>', 'Left', { noremap = false })
keymap('i', '<M-j>', '<down>', 'Down', { noremap = false })
keymap('i', '<M-k>', '<up>', 'Up', { noremap = false })
keymap('i', '<M-l>', '<right>', 'Right', { noremap = false })
keymap('t', '<M-h>', '<left>', 'Left')
keymap('t', '<M-j>', '<down>', 'Down')
keymap('t', '<M-k>', '<up>', 'Up')
keymap('t', '<M-l>', '<right>', 'Right')

-- Indenting -------------------------------------------------------------------
keymap('v', '>', '>gv', 'Shift lines right', { noremap = true })
keymap('v', '<', '<gv', 'Shift lines left', { noremap = true })

-- Filesystem navigation
keymap('n', '<leader>cd', [[<cmd>cd %:h<CR>]], 'CD to the current file')

-- Buffer ----------------------------------------------------------------------
keymap('n', '<BS>',      '<C-^>', 'Open previous file')
keymap('n', '<leader>bd', [[<cmd>bdelete<CR>]], 'Delete')
keymap('n', '<leader>bD', [[<cmd>bdelete<CR>]], 'Delete!')
keymap('n', '<C-n>', [[<cmd>bnext<CR>]], 'Next buffer')
keymap('n', '<C-p>', [[<cmd>bprevious<CR>]], 'Previous buffer')

-- Mini file explorer ----------------------------------------------------------
keymap('n', '<leader>ed', [[<cmd>lua MiniFiles.open()<CR>]],                             'Directory'     )
keymap('n', '<leader>ef', [[<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>]], 'File directory')

-- Mini pick -------------------------------------------------------------------
keymap('n', '<leader>do', [[<cmd>DiffviewOpen<CR>]],                           'Open Diffview')
keymap('n', '<leader>dc', [[<cmd>DiffviewClose<CR>]],                          'Close Diffview')
keymap('n', '<leader>dh', [[<cmd>DiffviewFileHistory<CR>]],                    'Open diffview file history')
keymap('n', '<leader>f/', [[<cmd>Pick history scope='/'<CR>]],                 '"/" history')
keymap('n', '<leader>f:', [[<cmd>Pick history scope=':'<CR>]],                 '":" history')
keymap('n', '<leader>fa', [[<cmd>Pick git_hunks scope='staged'<CR>]],          'Added hunks (all)')
keymap('n', '<leader>fA', [[<cmd>Pick git_hunks path='%' scope='staged'<CR>]], 'Added hunks (current)')
keymap('n', '<leader>fb', [[<cmd>Pick buffers include_current=false<CR>]],     'Buffers')
keymap('n', '<leader>fc', [[<cmd>Pick git_commits<CR>]],                       'Commits (all)')
keymap('n', '<leader>fC', [[<cmd>Pick git_commits path='%'<CR>]],              'Commits (current)')
keymap('n', '<leader>fd', [[<cmd>Pick diagnostic scope='all'<CR>]],            'Diagnostic workspace')
keymap('n', '<leader>fD', [[<cmd>Pick diagnostic scope='current'<CR>]],        'Diagnostic buffer')
keymap('n', '<leader>ff', [[<cmd>Pick files<CR>]],                             'Files')
keymap('n', '<leader>fg', [[<cmd>Pick grep_live<CR>]],                         'Grep live')
keymap('n', '<leader>fG', [[<cmd>Pick grep pattern='<cword>'<CR>]],            'Grep current word')
keymap('n', '<leader>fh', [[<cmd>Pick help<CR>]],                              'Help tags')
keymap('n', '<leader>fi', [[<cmd>Pick hl_groups<CR>]],                         'Highlight groups')
keymap('n', '<leader>fk', [[<cmd>Pick keymaps<CR>]],                           'Highlight groups')
keymap('n', '<leader>fm', [[<cmd>Pick git_hunks<CR>]],                         'Modified hunks (all)')
keymap('n', '<leader>fM', [[<cmd>Pick git_hunks path='%'<CR>]],                'Modified hunks (current)')
keymap('n', '<leader>fr', [[<cmd>Pick lsp scope='references'<CR>]],            'References (LSP)')
keymap('n', '<leader>fs', [[<cmd>Pick lsp scope='workspace_symbol'<CR>]],      'Symbols workspace (LSP)')
keymap('n', '<leader>fS', [[<cmd>Pick lsp scope='document_symbol'<CR>]],       'Symbols buffer (LSP)')
