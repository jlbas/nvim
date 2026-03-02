local utils = require('config.utils')

local default_opts = { noremap = true, silent = true }
local keymap = function(mode, keys, cmd, desc, opts)
  opts = vim.tbl_deep_extend('force', default_opts, opts or {})
  opts.desc = desc
  vim.keymap.set(mode, keys, cmd, opts)
end

keymap('n', '<leader>U', vim.pack.update, 'Update packages')

-- System clipboard ------------------------------------------------------------
keymap({'n', 'x'}, '<leader>cy', '"+y', 'Copy to system clipboard')
if os.getenv("TERM") == "foot" then
  keymap({'n', 'x'}, '<leader>cp', '"+p', 'Paste from system clipboard')
end

-- Search ----------------------------------------------------------------------
keymap('n', '<leader>i', ':let v:hlsearch = 1 - v:hlsearch<CR>', 'Toggle hlsearch')
keymap('x', '/', [[<esc>/\%V]], 'Search inside visual selection', { silent = false  })

-- Snippets --------------------------------------------------------------------
keymap({'i', 's'}, '<Esc>', function()
  vim.snippet.stop()
  return '<Esc>'
end, 'Stop snippets when leaving insert mode', { expr = true })

-- Window navigation -----------------------------------------------------------
keymap('n', '<C-h>', '<C-w>h', 'Focus on left window' )
keymap('n', '<C-j>', '<C-w>j', 'Focus on below window')
keymap('n', '<C-k>', '<C-w>k', 'Focus on above window')
keymap('n', '<C-l>', '<C-w>l', 'Focus on right window')
keymap('n', '<C-;>', '<C-w>p', 'Go to previous window')
keymap('i', '<C-;>', '<Esc>', 'Exit insert mode')

-- LSP other -------------------------------------------------------------------
keymap('n', '<C-}>', '<cmd>horizontal winc ]<CR>')

-- Window-Pick -----------------------------------------------------------------
keymap({'i', 'n', 't'}, '<C-,>', function()
  local cur = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_config(cur).relative ~= '' then
    vim.api.nvim_win_close(cur, true)
  end
  local win = utils.pick_win()
  if win ~= nil and win ~= vim.api.nvim_get_current_win() then
    vim.api.nvim_set_current_win(win)
  end
end, 'Pick window')
keymap('n', '<M-,>', function()
  local win1 = vim.api.nvim_get_current_win()
  local win2 = utils.pick_win()
  if win2 ~= nil and win1 ~= win2 then
    utils.feedkeys('mT')
    vim.schedule(function()
      vim.api.nvim_set_current_win(win2)
      utils.feedkeys('mY')
      utils.feedkeys('<C-w><C-p>', true)
      utils.feedkeys("'Y", true)
      utils.feedkeys('<C-w><C-p>', true)
      utils.feedkeys("'T")
    end)
  end
end, 'Swap windows')

-- Scrolling --------------------------------------------------------------------
keymap('n', '<leader>s', '<cmd>set scrollbind!<CR>', 'Toggle scrollbind')
keymap('n', '<leader>v', function()
  vim.o.scrolloff = vim.o.scrolloff == 5 and 999 or 5
end, 'Toggle vertical centering')

-- Window resizing -------------------------------------------------------------
keymap('n', '<M-h>', '"<cmd>vertical resize -" . v:count1 . "<CR>"', 'Decrease window width', { expr = true, replace_keycodes = false })
keymap('n', '<M-j>', '"<cmd>resize -" . v:count1 . "<CR>"', 'Decrease window height', { expr = true, replace_keycodes = false })
keymap('n', '<M-k>', '"<cmd>resize +" . v:count1 . "<CR>"', 'Increase window height', { expr = true, replace_keycodes = false })
keymap('n', '<M-l>', '"<cmd>vertical resize +" . v:count1 . "<CR>"', 'Increase window width', { expr = true, replace_keycodes = false })
keymap('n', '<M-=>', '<C-w>=', 'Make windows equally sized')
keymap('n', '<M-f>', [[<cmd>if winnr('$') == 1 | silent! close! | else | tab split | endif<CR>]], 'Toggle fullscreen')
-- Move with alt ---------------------------------------------------------------
keymap('c', '<M-h>', '<left>', 'Left', { silent = false })
keymap('c', '<M-l>', '<right>', 'Right', { silent = false })
keymap('i', '<M-h>', '<left>', 'Left', { noremap = false })
keymap('i', '<M-j>', '<down>', 'Down', { noremap = false })
keymap('i', '<M-k>', '<up>', 'Up', { noremap = false })
keymap('i', '<M-l>', '<right>', 'Right', { noremap = false })
keymap('n', '<M-t>', function()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  vim.cmd('tabnew')
  vim.api.nvim_win_set_buf(0, buf)
  vim.cmd('tabprevious')
  vim.api.nvim_win_close(win, false)
end, 'Send window to a new tab')

-- Indenting -------------------------------------------------------------------
keymap('v', '>', '>gv', 'Shift lines right', { noremap = true })
keymap('v', '<', '<gv', 'Shift lines left', { noremap = true })

-- Terminal --------------------------------------------------------------------
keymap('t', '<C-[><C-[>', '<C-\\><C-n>', 'Exit terminal mode' )
keymap('n', '<leader>t<CR>', [[<cmd>terminal<CR>]], 'New terminal')
keymap('n', '<leader>tt', [[<cmd>tabnew | terminal<CR>]], 'New terminal tab')
keymap('n', '<leader>ts', [[<cmd>split | terminal<CR>]], 'New terminal in split')
keymap('n', '<leader>tv', [[<cmd>vsplit | terminal<CR>]], 'New terminal in vertical split')
keymap('n', '<leader><CR>', utils.toggle_terms, 'Toggle all terminal splits visibility (tab-local)')

keymap('n', '<leader>tc', function()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == 'terminal' then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end, 'Delete all terminal buffers in current tab')

-- Filesystem navigation
keymap('n', '<leader>cd', [[<cmd>cd %:h<CR>]], 'CD to the current file')

-- Buffer ----------------------------------------------------------------------
keymap('n', '<C-p>', '<C-^>', 'Open previous file')

-- Tabs ------------------------------------------------------------------------
keymap('n', 'tt', [[<cmd>tabnew<CR>]], 'New tab')
keymap('n', 'tc', [[<cmd>tabclose<CR>]], 'Close tab')
keymap('n', 'tn', [[<cmd>tabnext<CR>]], 'Next tab')
keymap('n', 'tp', [[<cmd>tabprevious<CR>]], 'Previous tab')
keymap('n', 'tm', [[:tabmove<space>]], 'Move tab')
keymap('n', 'tl', [[<cmd>+tabmove<CR>]], 'Move tab to the right')
keymap('n', 'th', [[<cmd>-tabmove<CR>]], 'Move tab to the left')
keymap('n', 't;', [[<C-Tab>]], 'Go to last accessed tab')

local function find_conflict(dir)
  vim.cmd('silent! ' .. dir .. '\\v^[<=>|]{7}.*')
  vim.cmd('nohlsearch')
end
keymap({'n', 'x'}, ']x', function() find_conflict('/') end, 'Next git conflict')
keymap({'n', 'x'}, '[x', function() find_conflict('?') end, 'Next git conflict')

-- fzf-lua ---------------------------------------------------------------
local fzf = require('fzf-lua')
-- top pickers
keymap('n', "<leader>", function() fzf.builtin() end, "Pickers")
keymap('n', "<leader><space>", function() fzf.files() end, "Find Files")
keymap('n', "<leader>:", function() fzf.command_history() end, "Command History")
keymap('n', '<leader>/', function() fzf.search_history() end, "Search History")
-- find
keymap('n', "<leader>fC", function() fzf.files({ cwd = vim.fn.stdpath("config") }) end, "Find Config File")
keymap('n', "<leader>ff", function() fzf.files() end, "Find Files")
keymap('n', "<leader>,", function() fzf.buffers() end, "Buffers")
keymap('n', "<leader>fg", function() fzf.git_files() end, "Find Git Files")
keymap('n', "<leader>fr", function() fzf.oldfiles() end, "Recent")
-- git
keymap('n', "<leader>gb", function() fzf.git_blame() end, "Git Blame")
keymap('n', "<leader>gB", function() fzf.git_branches() end, "Git Branches")
keymap('n', "<leader>gl", function() fzf.git_commits() end, "Git Log")
keymap('n', "<leader>gL", function() fzf.git_bcommits() end, "Git Log Line")
keymap('n', "<leader>gs", function() fzf.git_status() end, "Git Status")
keymap('n', "<leader>gS", function() fzf.git_stash() end, "Git Stash")
keymap('n', "<leader>gd", function() fzf.git_diff() end, "Git Diff")
keymap('n', "<leader>gh", function() fzf.git_hunks() end, "Git Hunks")
keymap('n', "<leader>gt", function() fzf.git_tags() end, "Git Tags")
keymap('n', "<leader>gw", function() fzf.git_worktrees() end, "Git Worktrees")
-- grep
keymap('n', "<leader>fl", function() fzf.blines() end, "Buffer Lines")
keymap('n', "<leader>r", function() fzf.live_grep() end, "Grep")
keymap('n', "<leader>R", function() fzf.grep_cword() end, "Word")
keymap('x', "<leader>r", function() fzf.grep_visual() end, "Visual selection")
keymap('n', "<leader>B", function() fzf.lines() end, "Grep Open Buffers")
keymap({'n', 'x'}, "<leader>*", function()
  fzf.grep_cword({ filename = vim.fn.expand("%:.") })
end, "Current Word")
-- search/vim
keymap('n', '<leader>f"', function() fzf.registers() end, "Registers")
keymap('n', "<leader>fa", function() fzf.autocmds() end, "Autocmds")
keymap('n', "<leader>fc", function() fzf.commands() end, "Commands")
keymap('n', "<leader>fd", function() fzf.diagnostics_workspace() end, "Diagnostics")
keymap('n', "<leader>fD", function() fzf.diagnostics_document() end, "Buffer Diagnostics")
keymap('n', "<leader>fh", function() fzf.helptags() end, "Help Pages")
keymap('n', "<leader>fH", function() fzf.highlights() end, "Highlights")
keymap('n', "<leader>fi", function() fzf.filetypes() end, "Filetypes")
keymap('n', "<leader>fj", function() fzf.jumps() end, "Jumps")
keymap('n', "<leader>fk", function() fzf.keymaps() end, "Keymaps")
keymap('n', "<leader>fL", function() fzf.loclist() end, "Location List")
keymap('n', "<leader>fm", function() fzf.marks() end, "Marks")
keymap('n', "<leader>fM", function() fzf.manpages() end, "Man Pages")
keymap('n', "<leader>fq", function() fzf.quickfix() end, "Quickfix List")
keymap('n', "<leader>;", function() fzf.resume() end, "Resume")
keymap('n', "<leader>fu", function() fzf.undotree() end, "Undo History")
keymap('n', "<leader>fI", function() fzf.colorschemes() end, "Colorschemes")
keymap('n', "<leader>ft", function() fzf.treesitter() end, "Treesitter Symbols")
keymap('n', "<leader>fo", function() fzf.changes() end, "Changes")
keymap('n', "<leader>fp", function() fzf.tagstack() end, "Tagstack")
keymap('n', "<leader>fG", function() fzf.tags() end, "Tags")
keymap('n', "<leader>fS", function() fzf.spell_suggest() end, "Spell Suggest")
-- lsp
keymap('n', "gd", function() fzf.lsp_definitions() end, "Goto Definition")
keymap('n', "gD", function() fzf.lsp_declarations() end, "Goto Declaration")
keymap('n', "gr", function() fzf.lsp_references() end, "References", { nowait = true })
keymap('n', "gI", function() fzf.lsp_implementations() end, "Goto Implementation")
keymap('n', "gt", function() fzf.lsp_typedefs() end, "Goto Type Definition")
keymap('n', "gi", function() fzf.lsp_incoming_calls() end, "Incoming Calls")
keymap('n', "go", function() fzf.lsp_outgoing_calls() end, "Outgoing Calls")
keymap('n', "gs", function() fzf.lsp_document_symbols() end, "LSP Symbols")
keymap('n', "gS", function() fzf.lsp_workspace_symbols() end, "LSP Workspace Symbols")
keymap('n', "gF", function() fzf.lsp_finder() end, "LSP Finder")
keymap({'n', 'x'}, "ga", function() fzf.lsp_code_actions() end, "Code Actions")

-- other
keymap('n', "<leader>N", '<cmd>help news<CR>', "Neovim News")

return utils
