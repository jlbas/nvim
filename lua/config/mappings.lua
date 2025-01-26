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

-- LSP other -------------------------------------------------------------------
keymap('n', '<C-}>', '<cmd>horizontal winc ]<CR>')

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
keymap('t', '<C-[><C-[>', '<C-\\><C-n>', 'Exit terminal mode' )
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

-- Fugitive --------------------------------------------------------------------
keymap('n', '<leader>gb', [[<cmd>0,1Git blame<CR>]])
keymap('n', '<leader>g<CR>', [[<cmd>0,1Git ++curwin blame<CR>]])
keymap('n', '<leader>gv', [[<cmd>0,4Git blame<CR>]])
keymap('n', '<leader>gO', [[<cmd>0,5Git blame<CR>]])
keymap('n', '<leader>go', [[<cmd>Git difftool -y<CR>]])
keymap('n', '<leader>gq', [[<cmd>CloseFugitiveTabs<CR>]])
keymap('n', '<leader>gc', [[<cmd>Git commit<CR>]])
keymap('n', '<leader>gg', [[<cmd>Git<CR>]])
keymap('n', '<leader>gm', [[<cmd>Git mergetool<CR>]])
keymap('n', '<leader>gl', [[<cmd>Git log<CR>]])

-- Oil -------------------------------------------------------------------------
keymap('n', '<leader>o', function()
  require('oil.actions')[(vim.bo.filetype == 'oil') and 'close' or 'open_cwd'].callback()
end)

-- Snacks ---------------------------------------------------------------
-- bufdelete
keymap('n', '<leader>bd', function() require('snacks').bufdelete() end, "Delete Buffer")
-- picker
keymap('n', '<leader>fa', require('snacks').picker.autocmds, "Autocmds")
keymap('n', '<leader>fb', require('snacks').picker.buffers, "Buffers")
keymap('n', '<leader>fI', require('snacks').picker.colorschemes, "Colorschemes")
keymap('n', '<leader>f:', require('snacks').picker.command_history, "Command History")
keymap('n', '<leader>fc', require('snacks').picker.commands, "Commands")
keymap('n', '<leader>fC', function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, "Find Config File")
keymap('n', '<leader>fd', require('snacks').picker.diagnostics, "Diagnostics")
keymap('n', '<leader>ff', require('snacks').picker.files, "Find Files")
keymap('n', '<leader>fgb', require('snacks').picker.git_branches, "Git Branches")
keymap('n', '<leader>fgd', require('snacks').picker.git_diff, "Git Diff")
keymap('n', '<leader>fgf', require('snacks').picker.git_files, "Git Files")
keymap('n', '<leader>fgl', require('snacks').picker.git_log, "Git Log")
keymap('n', '<leader>fgs', require('snacks').picker.git_status, "Git Status")
keymap('n', '<leader>fr', require('snacks').picker.grep, "Grep")
keymap('n', '<leader>fB', require('snacks').picker.grep_buffers, "Grep Open Buffers")
keymap({'n', 'x'}, '<leader>fR', require('snacks').picker.grep_word, "Visual selection or word")
keymap('n', '<leader>fh', require('snacks').picker.help, "Help Pages")
keymap('n', '<leader>fH', require('snacks').picker.highlights, "Highlights")
keymap('n', '<leader>fj', require('snacks').picker.jumps, "Jumps")
keymap('n', '<leader>fk', require('snacks').picker.keymaps, "Keymaps")
keymap('n', '<leader>fl', require('snacks').picker.loclist, "Location List")
keymap('n', '<leader>fL', require('snacks').picker.lines, "Buffer Lines")
keymap('n', '<leader>fld', require('snacks').picker.lsp_definitions, "Goto Definition")
keymap('n', '<leader>flD', require('snacks').picker.lsp_declarations, "Goto Declarations")
keymap('n', '<leader>fli', require('snacks').picker.lsp_implementations, "Goto Implementation")
keymap('n', '<leader>flr', require('snacks').picker.lsp_references, "References", { nowait = true })
keymap('n', '<leader>fls', require('snacks').picker.lsp_symbols, "LSP Symbols")
keymap('n', '<leader>flt', require('snacks').picker.lsp_type_definitions, "Goto T[y]pe Definition")
keymap('n', '<leader>flS', require('snacks').picker.lsp_workspace_symbols, "LSP Workspace Symbols")
keymap('n', '<leader>fm', require('snacks').picker.man, "Man Pages")
keymap('n', '<leader>fM', require('snacks').picker.marks, "Marks")
keymap('n', '<leader>f', require('snacks').picker.pickers, "Pickers")
keymap('n', '<leader>fp', require('snacks').picker.pickers, "Pickers")
keymap('n', '<leader>fpa', require('snacks').picker.picker_actions, "Picker Actions")
keymap('n', '<leader>fpf', require('snacks').picker.picker_format, "Picker Format")
keymap('n', '<leader>fpl', require('snacks').picker.picker_layouts, "Picker Layouts")
keymap('n', '<leader>fpp', require('snacks').picker.picker_preview, "Picker Preview")
keymap('n', '<leader>fw', require('snacks').picker.projects, "Projects")
keymap('n', '<leader>fq', require('snacks').picker.qflist, "Quickfix List")
keymap('n', '<leader>fo', require('snacks').picker.recent, "Recent")
keymap('n', '<leader>f"', require('snacks').picker.registers, "Registers")
keymap('n', '<leader>f;', require('snacks').picker.resume, "Resume")
keymap('n', '<leader>f/', require('snacks').picker.search_history, "Search History")
keymap('n', '<leader>fs', require('snacks').picker.smart, "Smart")
keymap('n', '<leader>fS', require('snacks').picker.spelling, "Spelling")
keymap('n', '<leader>fu', require('snacks').picker.undo, "Undo")
-- scratch
-- keymap('n', '<leader>.', function() require('snacks').scratch() end, "Toggle Scratch Buffer")
-- keymap('n', '<leader>s', require('snacks').scratch.select, "Select Scratch Buffer")

-- FZF -------------------------------------------------------------------------
-- keymap('n', '<leader>f', require('fzf-lua').builtin, '')
-- keymap('n', '<leader>f:', require('fzf-lua').command_history, '')
-- keymap('n', '<leader>f/', require('fzf-lua').search_history, '')
-- keymap('n', '<leader>fB', require('fzf-lua').lines, '')
-- keymap('n', '<leader>fC', require('fzf-lua').changes, '')
-- keymap('n', '<leader>fI', require('fzf-lua').colorschemes, '')
-- keymap('n', '<leader>fM', require('fzf-lua').manpages, '')
-- keymap('n', '<leader>fR', require('fzf-lua').grep_cword, '')
-- keymap('n', '<leader>fa', require('fzf-lua').autocmds, '')
-- keymap('n', '<leader>fb', require('fzf-lua').buffers, '')
-- keymap('n', '<leader>fc', require('fzf-lua').commands, '')
-- keymap('n', '<leader>ff', require('fzf-lua').files, '')
-- keymap('n', '<leader>fgb', require('fzf-lua').git_branches, '')
-- keymap('n', '<leader>fgB', require('fzf-lua').git_bcommits, '')
-- keymap('n', '<leader>fgc', require('fzf-lua').git_commits, '')
-- keymap('n', '<leader>fgs', require('fzf-lua').git_status, '')
-- keymap('n', '<leader>fh', require('fzf-lua').helptags, '')
-- keymap('n', '<leader>fi', require('fzf-lua').highlights, '')
-- keymap('n', '<leader>fj', require('fzf-lua').jumps, '')
-- keymap('n', '<leader>fk', require('fzf-lua').keymaps, '')
-- keymap('n', '<leader>flC', require('fzf-lua').lsp_outgoing_calls, '')
-- keymap('n', '<leader>flD', require('fzf-lua').lsp_declarations, '')
-- keymap('n', '<leader>flL', require('fzf-lua').lsp_workspace_diagnostics, '')
-- keymap('n', '<leader>flS', require('fzf-lua').lsp_workspace_symbols, '')
-- keymap('n', '<leader>fla', require('fzf-lua').lsp_code_actions, '')
-- keymap('n', '<leader>flc', require('fzf-lua').lsp_incoming_calls, '')
-- keymap('n', '<leader>fld', require('fzf-lua').lsp_definitions, '')
-- keymap('n', '<leader>flf', require('fzf-lua').lsp_finder, '')
-- keymap('n', '<leader>fli', require('fzf-lua').lsp_implementations, '')
-- keymap('n', '<leader>fll', require('fzf-lua').lsp_document_diagnostics, '')
-- keymap('n', '<leader>flr', require('fzf-lua').lsp_references, '')
-- keymap('n', '<leader>fls', require('fzf-lua').lsp_document_symbols, '')
-- keymap('n', '<leader>flt', require('fzf-lua').lsp_typedefs, '')
-- keymap('n', '<leader>fm', require('fzf-lua').marks, '')
-- keymap('n', '<leader>fo', require('fzf-lua').oldfiles, '')
-- keymap('n', '<leader>fp', require('fzf-lua').resume, '')
-- keymap('n', '<leader>fr', require('fzf-lua').live_grep_native, '')
-- keymap('n', '<leader>fs', require('fzf-lua').spell_suggest, '')
-- keymap('n', '<leader>ft', require('fzf-lua').tabs, '')
-- keymap('n', '<leader>fy', require('fzf-lua').registers, '')
-- keymap('x', '<leader>fr', require('fzf-lua').grep_visual, '')

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
