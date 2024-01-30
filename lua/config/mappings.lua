local default_opts = { noremap = true, silent = true }
local keymap = function(mode, keys, cmd, desc, opts)
  opts = vim.tbl_deep_extend('force', default_opts, opts or {})
  opts.desc = desc
  vim.keymap.set(mode, keys, cmd, opts)
end

local M = {}

M.get_selected_text = function()
  local old_reg = vim.fn.getreg('"')
  local old_reg_type = vim.fn.getregtype('"')
  vim.cmd('norm gvy')
  local ret = vim.fn.getreg('"')
  vim.fn.setreg('"', old_reg, old_reg_type)
  vim.cmd([[norm \<ESC>]])
  return tostring(ret)
end

-- System clipboard ------------------------------------------------------------
keymap({'n', 'x'}, '<leader>cy', '"+y', 'Copy to system clipboard')
-- keymap({'n', 'x'}, '<leader>cp', '"+p', 'Paste from system clipboard') -- not supported in Wezterm

-- Search ----------------------------------------------------------------------
keymap('n', '<leader>i', ':let v:hlsearch = 1 - v:hlsearch<CR>', 'Toggle hlsearch')
keymap('x', '/', [[<esc>/\%V]], 'Search inside visual selection', { silent = false  })

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
keymap('n', '<M-f>', [[<cmd>if winnr('$') == 1 | silent! close! | else | tab split | endif<CR>]], 'Toggle fullscreen')
keymap('n', '<M-z>', [[<cmd>ZenMode<CR>]], 'Toggle ZenMode')

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

-- Quickfix --------------------------------------------------------------------
keymap('n', '<leader>q', 'empty(filter(getwininfo(), "v:val.quickfix")) ? ":cope<CR>" : ":ccl<CR>"', 'Toggle quickfix', { expr = true })

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

-- Diffview --------------------------------------------------------------------
keymap('n', '<leader>go', [[<cmd>DiffviewOpen<CR>]],                           'Open Diffview')
keymap('n', '<leader>gc', [[<cmd>DiffviewClose<CR>]],                          'Close Diffview')
keymap('n', '<leader>gh', [[<cmd>DiffviewFileHistory<CR>]],                    'Open diffview file history')

-- FZF -------------------------------------------------------------------------
keymap('n', '<leader>ff', [[<cmd>Files<CR>]], '')
keymap('n', '<leader>fF', [[<cmd>GFiles<CR>]], '')
keymap('n', '<leader>fb', [[<cmd>Buffers<CR>]], '')
keymap('n', '<leader>fh', [[<cmd>Colors<CR>]], '')
keymap('n', '<leader>fr', [[<cmd>Rg<CR>]], '')
keymap('x', '<leader>fr', [[:lua vim.cmd('Rg ' .. require('config.mappings').get_selected_text())<CR>]], '')
keymap('n', '<leader>fR', [[:Rg <C-R><C-W><CR>]], '')
keymap('n', '<leader>fl', [[<cmd>Lines<CR>]], '')
keymap('n', '<leader>fL', [[<cmd>BLines<CR>]], '')
keymap('n', '<leader>fg', [[<cmd>Changes<CR>]], '')
keymap('n', '<leader>fm', [[<cmd>Marks<CR>]], '')
keymap('n', '<leader>fj', [[<cmd>Jumps<CR>]], '')
keymap('n', '<leader>f:', [[<cmd>History:<CR>]], '')
keymap('n', '<leader>f/', [[<cmd>History/<CR>]], '')
keymap('n', '<leader>fs', [[<cmd>Snippets<CR>]], '')
keymap('n', '<leader>fC', [[<cmd>Commits<CR>]], '')
keymap('n', '<leader>fB', [[<cmd>BCommits<CR>]], '')
keymap('n', '<leader>fc', [[<cmd>Commands<CR>]], '')
keymap('n', '<leader>fk', [[<cmd>Maps<CR>]], '')
keymap('n', '<leader>fh', [[<cmd>Helptags<CR>]], '')

-- DAP -------------------------------------------------------------------------
keymap('n', '<leader>db', require('dap').toggle_breakpoint, '')
keymap('n', '<leader>dB', require('dap').clear_breakpoints, '')
keymap('n', '<leader>dc', require('dap').continue, '')
keymap('n', '<leader>dC', require('dap').run_to_cursor, '')
keymap('n', '<leader>di', require('dap').step_into, '')
keymap('n', '<leader>dl', require('dap').list_breakpoints, '')
keymap('n', '<leader>dL', [[<cmd>require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>]], '')
keymap('n', '<leader>dq', require('dap').terminate, '')
keymap('n', '<leader>dr', require('dap').repl.toggle, '')
keymap('n', '<leader>dn', require('dap').step_over, '')
keymap('n', '<leader>do', require('dap').step_out, '')

-- Mini pick -------------------------------------------------------------------
-- keymap('n', '<leader>f/', [[<cmd>Pick history scope='/'<CR>]],                 '"/" history')
-- keymap('n', '<leader>f:', [[<cmd>Pick history scope=':'<CR>]],                 '":" history')
-- keymap('n', '<leader>fa', [[<cmd>Pick git_hunks scope='staged'<CR>]],          'Added hunks (all)')
-- keymap('n', '<leader>fA', [[<cmd>Pick git_hunks path='%' scope='staged'<CR>]], 'Added hunks (current)')
-- keymap('n', '<leader>fb', [[<cmd>Pick buffers include_current=false<CR>]],     'Buffers')
-- keymap('n', '<leader>fc', [[<cmd>Pick commands<CR>]],                          'Commands (all)')
-- keymap('n', '<leader>fd', [[<cmd>Pick diagnostic scope='all'<CR>]],            'Diagnostic workspace')
-- keymap('n', '<leader>fD', [[<cmd>Pick diagnostic scope='current'<CR>]],        'Diagnostic buffer')
-- keymap('n', '<leader>ff', [[<cmd>Pick files<CR>]],                             'Files')
-- keymap('n', '<leader>fg', [[<cmd>Pick grep_live<CR>]],                         'Grep live')
-- keymap('n', '<leader>fG', [[<cmd>Pick grep pattern='<cword>'<CR>]],            'Grep current word')
-- keymap('n', '<leader>fh', [[<cmd>Pick help<CR>]],                              'Help tags')
-- keymap('n', '<leader>fi', [[<cmd>Pick hl_groups<CR>]],                         'Highlight groups')
-- keymap('n', '<leader>fk', [[<cmd>Pick keymaps<CR>]],                           'Highlight groups')
-- keymap('n', '<leader>fm', [[<cmd>Pick git_hunks<CR>]],                         'Modified hunks (all)')
-- keymap('n', '<leader>fM', [[<cmd>Pick git_hunks path='%'<CR>]],                'Modified hunks (current)')
-- keymap('n', '<leader>fr', [[<cmd>Pick lsp scope='references'<CR>]],            'References (LSP)')
-- keymap('n', '<leader>fs', [[<cmd>Pick lsp scope='workspace_symbol'<CR>]],      'Symbols workspace (LSP)')
-- keymap('n', '<leader>fS', [[<cmd>Pick lsp scope='document_symbol'<CR>]],       'Symbols buffer (LSP)')
-- keymap('n', '<leader>fp', [[<cmd>Pick visit_paths cwd=''<CR>]],                'Visit paths (all)')
-- keymap('n', '<leader>fP', [[<cmd>Pick visit_paths<CR>]],                       'Visit paths (cwd)')
-- keymap('n', '<leader>fv', [[<cmd>Pick visit_labels cwd=''<CR>]],               'Visit labels (all)')
-- keymap('n', '<leader>fV', [[<cmd>Pick visit_labels<CR>]],                      'Visit labels (cwd)')

return M
