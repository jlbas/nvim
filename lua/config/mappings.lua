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
keymap('n', '<C-;>', '<C-w>p', 'Go to previous window')

-- Window-Pick -----------------------------------------------------------------
keymap('n', '<C-q>', require('nvim-window').pick, 'Pick window')
keymap('n', '<M-q>', function()
  local prev_win = vim.api.nvim_get_current_win()
  require('nvim-window').pick()
  local cur_win = vim.api.nvim_get_current_win()
  if prev_win ~= cur_win then
    local prev_buf = vim.api.nvim_win_get_buf(prev_win);
    local cur_buf = vim.api.nvim_win_get_buf(cur_win);
    vim.api.nvim_win_set_buf(cur_win, prev_buf)
    vim.api.nvim_win_set_buf(prev_win, cur_buf)
  end
end, 'Move window to another pane')

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

-- Indenting -------------------------------------------------------------------
keymap('v', '>', '>gv', 'Shift lines right', { noremap = true })
keymap('v', '<', '<gv', 'Shift lines left', { noremap = true })

-- Terminal --------------------------------------------------------------------
keymap('t', '<C-h>', '<C-\\><C-n><C-w>h', 'Focus on left window' )
keymap('t', '<C-j>', '<C-\\><C-n><C-w>j', 'Focus on below window')
keymap('t', '<C-k>', '<C-\\><C-n><C-w>k', 'Focus on above window')
keymap('t', '<C-l>', '<C-\\><C-n><C-w>l', 'Focus on right window')
keymap('t', '<C-;>', '<C-\\><C-n><C-w>p', 'Go to previous window')
keymap('n', '<leader>tt', [[<cmd>terminal<CR>]], 'New terminal')
keymap('n', '<leader>ts', [[<cmd>split | terminal<CR>]], 'New terminal in split')
keymap('n', '<leader>tv', [[<cmd>vsplit | terminal<CR>]], 'New terminal in vertical split')

-- Filesystem navigation
keymap('n', '<leader>cd', [[<cmd>cd %:h<CR>]], 'CD to the current file')

-- Buffer ----------------------------------------------------------------------
keymap('n', '<BS>',      '<C-^>', 'Open previous file')
keymap('n', '<C-n>', [[<cmd>bnext<CR>]], 'Next buffer')
keymap('n', '<C-p>', [[<cmd>bprevious<CR>]], 'Previous buffer')

-- Tabs ------------------------------------------------------------------------
keymap('n', 'tt', [[<cmd>tabnew<CR>]], 'New tab')
keymap('n', 'tc', [[<cmd>tabclose<CR>]], 'New tab')
keymap('n', 'tn', [[<cmd>tabnext<CR>]], 'Next tab')
keymap('n', 'tp', [[<cmd>tabprevious<CR>]], 'Previous tab')
keymap('n', 'tm', [[:tabmove<space>]], 'Move tab')
keymap('n', 'tl', [[<cmd>+tabmove<CR>]], 'Move tab to the right')
keymap('n', 'th', [[<cmd>-tabmove<CR>]], 'Move tab to the left')
keymap('n', 't;', [[<C-Tab>]], 'Go to last accessed tab')

-- Copilot ---------------------------------------------------------------------
keymap('n', '<leader>cc', [[<cmd>CopilotChatToggle<CR>]], 'CopilotChat - Toggle')
keymap('x', '<leader>cc', [[<cmd>CopilotChatToggle<CR>]], 'CopilotChat - Toggle')
keymap('n', '<leader>ci', [[:CopilotChat<space>]], 'CopilotChat - Open with input')
keymap('x', '<leader>ci', [[:CopilotChat<space>]], 'CopilotChat - Open with input')
keymap('x', '<leader>ce', [[<cmd>CopilotChatExplain<CR>]], 'CopilotChat - Explain')
keymap('x', '<leader>cr', [[<cmd>CopilotChatReview<CR>]], 'CopilotChat - Review')
keymap('x', '<leader>cf', [[<cmd>CopilotChatFix<CR>]], 'CopilotChat - Fix')
keymap('x', '<leader>co', [[<cmd>CopilotChatOptimize<CR>]], 'CopilotChat - Optimize')
keymap('x', '<leader>ct', [[<cmd>CopilotChatTests<CR>]], 'CopilotChat - Tests')

-- Mini file explorer ----------------------------------------------------------
keymap('n', '<leader>ed', [[<cmd>lua MiniFiles.open()<CR>]],                             'Directory'     )
keymap('n', '<leader>ef', [[<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>]], 'File directory')

-- Diffview --------------------------------------------------------------------
keymap('n', '<leader>go', [[<cmd>DiffviewOpen<CR>]],                           'Open Diffview')
keymap('n', '<leader>gc', [[<cmd>DiffviewClose<CR>]],                          'Close Diffview')
keymap('n', '<leader>gh', [[<cmd>DiffviewFileHistory<CR>]],                    'Open diffview file history')
keymap('n', '<leader>gg', function()
  local ns_id = vim.api.nvim_get_namespaces()["gitsigns_blame"]
  local extmarks = vim.api.nvim_buf_get_extmarks(0, ns_id, 0, -1, {details=true})[1]
  if extmarks then
    local sha = extmarks[4]["virt_text"][1][1]:sub(2,9)
    if sha:find('%w%w%w%w%w%w%w%w') then
      vim.cmd("DiffviewOpen " .. sha .. "^!")
    end
  end
end, 'Open commit hash in diffview')

local function fzf_notes()
  require('fzf-lua').files({ cwd = '~/onedrive/notes/' })
end

local function open_ws_notes()
  local branch = require('lualine.components.branch.git_branch').get_branch()
  if branch ~= '' then
    local file = vim.fn.expand('~/onedrive/notes/' .. branch .. '.md')
    if vim.fn.filereadable(file) == 0 then
      vim.fn.writefile({ '# ' .. string.gsub("-"..branch, "%W%l", string.upper):sub(2) }, file)
    end
    vim.cmd('edit ' .. file)
  else
    fzf_notes()
  end
end

-- FZF -------------------------------------------------------------------------
keymap('n', '<leader>f', require('fzf-lua').builtin, '')
keymap('n', '<leader>f:', require('fzf-lua').command_history, '')
keymap('n', '<leader>f/', require('fzf-lua').search_history, '')
keymap('n', '<leader>fB', require('fzf-lua').lines, '')
keymap('n', '<leader>fC', require('fzf-lua').changes, '')
keymap('n', '<leader>fI', require('fzf-lua').colorschemes, '')
keymap('n', '<leader>fM', require('fzf-lua').manpages, '')
keymap('n', '<leader>fR', require('fzf-lua').grep_cword, '')
keymap('n', '<leader>fa', require('fzf-lua').autocmds, '')
keymap('n', '<leader>fb', require('fzf-lua').buffers, '')
keymap('n', '<leader>fc', require('fzf-lua').commands, '')
keymap('n', '<leader>ff', require('fzf-lua').files, '')
keymap('n', '<leader>fgb', require('fzf-lua').git_bcommits, '')
keymap('n', '<leader>fgc', require('fzf-lua').git_commits, '')
keymap('n', '<leader>fgs', require('fzf-lua').git_status, '')
keymap('n', '<leader>fh', require('fzf-lua').helptags, '')
keymap('n', '<leader>fi', require('fzf-lua').highlights, '')
keymap('n', '<leader>fj', require('fzf-lua').jumps, '')
keymap('n', '<leader>fk', require('fzf-lua').keymaps, '')
keymap('n', '<leader>flC', require('fzf-lua').lsp_outgoing_calls, '')
keymap('n', '<leader>flD', require('fzf-lua').lsp_declarations, '')
keymap('n', '<leader>flL', require('fzf-lua').lsp_workspace_diagnostics, '')
keymap('n', '<leader>flS', require('fzf-lua').lsp_workspace_symbols, '')
keymap('n', '<leader>fla', require('fzf-lua').lsp_code_actions, '')
keymap('n', '<leader>flc', require('fzf-lua').lsp_incoming_calls, '')
keymap('n', '<leader>fld', require('fzf-lua').lsp_definitions, '')
keymap('n', '<leader>flf', require('fzf-lua').lsp_finder, '')
keymap('n', '<leader>fli', require('fzf-lua').lsp_implementations, '')
keymap('n', '<leader>fll', require('fzf-lua').lsp_document_diagnostics, '')
keymap('n', '<leader>flr', require('fzf-lua').lsp_references, '')
keymap('n', '<leader>fls', require('fzf-lua').lsp_document_symbols, '')
keymap('n', '<leader>flt', require('fzf-lua').lsp_typedefs, '')
keymap('n', '<leader>fm', require('fzf-lua').marks, '')
keymap('n', '<leader>fn', open_ws_notes, '')
keymap('n', '<leader>fN', fzf_notes, '')
keymap('n', '<leader>fp', require('fzf-lua').resume, '')
keymap('n', '<leader>fr', require('fzf-lua').live_grep_native, '')
keymap('n', '<leader>fs', require('fzf-lua').spell_suggest, '')
keymap('n', '<leader>ft', require('fzf-lua').tabs, '')
keymap('n', '<leader>fy', require('fzf-lua').registers, '')
keymap('x', '<leader>fr', require('fzf-lua').grep_visual, '')

-- DAP -------------------------------------------------------------------------
keymap('n', '<leader>db', require('dap').toggle_breakpoint, '')
keymap('n', '<leader>dB', require('dap').clear_breakpoints, '')
keymap('n', '<leader>dc', require('dap').continue, '')
keymap('n', '<leader>dC', require('dap').run_to_cursor, '')
keymap('n', '<leader>dd', require('dap').repl.toggle, '')
keymap('n', '<leader>di', require('dap').step_into, '')
keymap('n', '<leader>dl', require('dap').list_breakpoints, '')
keymap('n', '<leader>dL', [[<cmd>require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>]], '')
keymap('n', '<leader>dq', require('dap').terminate, '')
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
