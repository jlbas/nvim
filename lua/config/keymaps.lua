local default_opts = { noremap = true, silent = true }
local keymap = function(mode, keys, cmd, desc, opts)
  opts = vim.tbl_deep_extend('force', default_opts, opts or {})
  opts.desc = desc
  vim.keymap.set(mode, keys, cmd, opts)
end

local function feedkeys(keys, replace_termcodes)
  if replace_termcodes then
    keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  end
  vim.api.nvim_feedkeys(keys, 'n', true)
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
  local win = require('snacks').picker.util.pick_win()
  if win ~= nil and win ~= vim.api.nvim_get_current_win() then
    vim.api.nvim_set_current_win(win)
  end
end, 'Pick window')
keymap('n', '<M-,>', function()
  local win1 = vim.api.nvim_get_current_win()
  local win2 = require('snacks').picker.util.pick_win()
  if win2 ~= nil and win1 ~= win2 then
    feedkeys('mT')
    vim.schedule(function()
      vim.api.nvim_set_current_win(win2)
      feedkeys('mY')
      feedkeys('<C-w><C-p>', true)
      feedkeys("'Y", true)
      feedkeys('<C-w><C-p>', true)
      feedkeys("'T")
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
keymap('n', '<M-z>', [[<cmd>ZenMode<CR>]], 'Toggle ZenMode')

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

-- Comments --------------------------------------------------------------------
if IS_WORK then
  keymap('n', 'gdd', function()
    local line = vim.api.nvim_get_current_line()
    local marker = '// DO_NOT_COMMIT'
    if line:find(marker, 1, true) then
      local new_line = line:gsub('%s*' .. marker .. ".*$", "")
      vim.api.nvim_set_current_line(new_line)
    else
      vim.api.nvim_set_current_line(line:gsub('%s*$', '') .. ' ' .. marker)
    end
  end, 'Toggle DO_NOT_COMMIT comment')
end

-- Terminal --------------------------------------------------------------------
keymap('t', '<C-[><C-[>', '<C-\\><C-n>', 'Exit terminal mode' )
keymap('n', '<leader>t<CR>', [[<cmd>terminal<CR>]], 'New terminal')
keymap('n', '<leader>tt', [[<cmd>tabnew | terminal<CR>]], 'New terminal tab')
keymap('n', '<leader>ts', [[<cmd>split | terminal<CR>]], 'New terminal in split')
keymap('n', '<leader>tv', [[<cmd>vsplit | terminal<CR>]], 'New terminal in vertical split')

local hidden_terms = {}
keymap('n', '<leader><CR>', function()
  local cur_tab = vim.api.nvim_get_current_tabpage()
  hidden_terms[cur_tab] = hidden_terms[cur_tab] or {}
  local term_bufs = hidden_terms[cur_tab]
  local wins = vim.api.nvim_tabpage_list_wins(cur_tab)

  if #term_bufs > 0 then
    local valid_bufs = {}
    local open_bufs = {}
    for _, win in ipairs(wins) do
      open_bufs[vim.api.nvim_win_get_buf(win)] = true
    end
    for _, buf in ipairs(term_bufs) do
      if vim.api.nvim_buf_is_valid(buf) and not open_bufs[buf] then
        table.insert(valid_bufs, buf)
      end
    end
    hidden_terms[cur_tab] = valid_bufs
    term_bufs = valid_bufs
  end

  local cur_term_wins = {}
  local cur_term_bufs = {}

  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_get_option(buf, 'buftype') == 'terminal' then
      table.insert(cur_term_wins, win)
      table.insert(cur_term_bufs, buf)
    end
  end

  if #term_bufs > 0 then
    local prev_win = vim.api.nvim_get_current_win()
    vim.cmd('vsplit')
    vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), term_bufs[1])
    vim.cmd('wincmd L')
    for i = 2, #term_bufs do
      vim.cmd('split')
      vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), term_bufs[i])
    end
    vim.api.nvim_set_current_win(prev_win)
    hidden_terms[cur_tab] = vim.api.nvim_tabpage_is_valid(cur_tab) and {} or nil
  elseif #cur_term_wins > 0 then
    hidden_terms[cur_tab] = vim.deepcopy(cur_term_bufs)
    for _, win in ipairs(cur_term_wins) do
      vim.api.nvim_win_close(win, false)
    end
  else
    vim.cmd('vsplit | wincmd L | terminal')
  end
end, 'Toggle all terminal splits visibility (tab-local)')

keymap('n', '<leader>tc', function()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_get_option(buf, 'buftype') == 'terminal' then
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
keymap('n', 'tc', [[<cmd>tabclose<CR>]], 'New tab')
keymap('n', 'tn', [[<cmd>tabnext<CR>]], 'Next tab')
keymap('n', 'tp', [[<cmd>tabprevious<CR>]], 'Previous tab')
keymap('n', 'tm', [[:tabmove<space>]], 'Move tab')
keymap('n', 'tl', [[<cmd>+tabmove<CR>]], 'Move tab to the right')
keymap('n', 'th', [[<cmd>-tabmove<CR>]], 'Move tab to the left')
keymap('n', 't;', [[<C-Tab>]], 'Go to last accessed tab')

-- Markdown --------------------------------------------------------------------
keymap({'n', 'i'}, '<C-m>', [[<cmd>Markview toggle<CR>]], 'Toggle Markview')

-- CodeCompanion ---------------------------------------------------------------
if package.loaded['codecompanion'] then
  local function goto_last_chat_buffer()
    local bufnr = require("codecompanion.strategies.chat").last_chat().bufnr
    local wins = vim.fn.win_findbuf(bufnr)
    if wins[1] then
      vim.fn.win_gotoid(wins[1])
    end
  end

  keymap('n', '<leader>ca', [[<cmd>CodeCompanionActions<CR>]], 'Open CodeCompanion action palette')
  keymap({'n', 'v'}, '<leader>cc', [[<cmd>CodeCompanionChat Toggle<CR>]], 'Toggle CodeCompanion chat')
  keymap('v', '<leader>ca', function()
    vim.cmd('CodeCompanionChat Add')
    feedkeys('<Esc>', true)
    goto_last_chat_buffer()
  end, 'Add visually selected text to chat')
  keymap('v', '<leader>cp', [[<cmd>CodeCompanion<CR>]], 'CodeCompanion prompt')

  keymap({'i', 'n'}, '<C-CR>', function() vim.g.copilot_enabled = not vim.g.copilot_enabled end, 'Toggle Copilot', { silent = true })
  keymap('i', '<C-\'>', '<Plug>(copilot-next)', 'Next suggestion', { silent = true })
  keymap('i', '<C-;>', '<Plug>(copilot-previous)', 'Previous suggestion', { silent = true })
  keymap('i', '<C-h>', '<Plug>(copilot-dismiss)', 'Dismiss suggestion', { silent = true })
  keymap('i', '<C-j>', '<Plug>(copilot-accept-word)', 'Accept word', { silent = true })
  keymap('i', '<C-l>', 'copilot#Accept("\\<CR>")', 'Accept suggestion', { expr = true, replace_keycodes = false, silent = true })
end

if IS_WORK then
  local function fzf_notes()
    require('snacks').picker.files({ cwd = '~/OneDrive/notes/' })
  end

  local function open_ws_notes(action)
    action = action or 'edit'
    local branch = require('lualine.components.branch.git_branch').get_branch()
    if branch ~= '' then
      local file = vim.fn.expand('~/OneDrive/notes/' .. branch .. '.md')
      if vim.fn.filereadable(file) == 0 then
        vim.fn.writefile({ '# ' .. string.gsub("-"..branch, "%W%l", string.upper):sub(2) }, file)
      end
      vim.cmd(action .. ' ' .. file)
    else
      fzf_notes()
    end
  end

  keymap('n', '<leader>fn', fzf_notes, '')
  keymap('n', '<leader>nn', function() open_ws_notes() end, '')
  keymap('n', '<leader>n<CR>', function() open_ws_notes() end, '')
  keymap('n', '<leader>ns', function() open_ws_notes('split') end, '')
  keymap('n', '<leader>nv', function() open_ws_notes('vsplit') end, '')
  keymap('n', '<leader>nt', function() open_ws_notes('tabedit') end, '')
end

local function find_conflict(dir)
  vim.cmd('silent! ' .. dir .. '\\v^[<=>|]{7}.*')
  vim.cmd('nohlsearch')
end
keymap({'n', 'x'}, ']x', function() find_conflict('/') end, 'Next git conflict')
keymap({'n', 'x'}, '[x', function() find_conflict('?') end, 'Next git conflict')

-- Oil -------------------------------------------------------------------------
keymap('n', '<leader>o', function()
  require('oil.actions')[(vim.bo.filetype == 'oil') and 'close' or 'open_cwd'].callback()
end)

-- Snacks ---------------------------------------------------------------
-- top pickers & explorer
keymap('n', "<leader>", function() Snacks.picker.pickers() end, "Pickers")
keymap('n', "<leader><space>", function() Snacks.picker.smart() end, "Smart Find Files")
keymap('n', "<leader>:", function() Snacks.picker.command_history() end, "Command History")
keymap('n', '<leader>/', function() Snacks.picker.search_history({sort={fields={"score:desc", "idx"}}}) end, "Search History")
keymap('n', "<leader>n", function() Snacks.picker.notifications() end, "Notification History")
keymap('n', "<leader>e", function() Snacks.explorer() end, "File Explorer")
-- find
keymap('n', "<leader>fC", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, "Find Config File")
keymap('n', "<leader>ff", function() Snacks.picker.files() end, "Find Files")
keymap('n', "<leader>,", function() Snacks.picker.buffers() end, "Buffers")
keymap('n', "<leader>fg", function() Snacks.picker.git_files() end, "Find Git Files")
keymap('n', "<leader>fp", function() Snacks.picker.projects() end, "Projects")
keymap('n', "<leader>fr", function() Snacks.picker.recent() end, "Recent")
-- git
keymap('n', "<leader>gb", function() Snacks.picker.git_branches() end, "Git Branches")
keymap('n', "<leader>gl", function() Snacks.picker.git_log() end, "Git Log")
keymap('n', "<leader>gL", function() Snacks.picker.git_log_line() end, "Git Log Line")
keymap('n', "<leader>gs", function() Snacks.picker.git_status() end, "Git Status")
keymap('n', "<leader>gS", function() Snacks.picker.git_stash() end, "Git Stash")
keymap('n', "<leader>gd", function() Snacks.picker.git_diff() end, "Git Diff (Hunks)")
keymap('n', "<leader>gf", function() Snacks.picker.git_log_file() end, "Git Log File")
-- grep
keymap('n', "<leader>fl", function() Snacks.picker.lines() end, "Buffer Lines")
keymap('n', "<leader>r", function() Snacks.picker.grep({ args = { '-g', '!customlog*' } }) end, "Grep")
keymap('n', "<leader>R", function() Snacks.picker.grep_word({ args = { '--word-regexp', '-g', '!customlog*' } }) end, "Word")
keymap('x', "<leader>r", function() Snacks.picker.grep_word({ args = { '-g', '!customlog*' } }) end, "Visual selection")
keymap('n', "<leader>B", function() Snacks.picker.grep_buffers() end, "Grep Open Buffers")
-- keymap('n', "<leader>*", function() Snacks.picker.lines({ pattern = vim.fn.expand("<cword>") }) end, "Current Word")
keymap({'n', 'x'}, "<leader>*", function()
  Snacks.picker.grep_word({
    args = { '--word-regexp' },
    glob = { vim.fn.expand("%:.") },
    layout = {
      preset = 'ivy',
      preview = 'main',
    },
  })
end, "Current Word")
keymap('n', '<leader>f"', function() Snacks.picker.registers() end, "Registers")
keymap('n', "<leader>fa", function() Snacks.picker.autocmds() end, "Autocmds")
keymap('n', "<leader>fc", function() Snacks.picker.commands() end, "Commands")
keymap('n', "<leader>fd", function() Snacks.picker.diagnostics() end, "Diagnostics")
keymap('n', "<leader>fD", function() Snacks.picker.diagnostics_buffer() end, "Buffer Diagnostics")
keymap('n', "<leader>fh", function() Snacks.picker.help() end, "Help Pages")
keymap('n', "<leader>fH", function() Snacks.picker.highlights() end, "Highlights")
keymap('n', "<leader>fi", function() Snacks.picker.icons() end, "Icons")
keymap('n', "<leader>fj", function() Snacks.picker.jumps() end, "Jumps")
keymap('n', "<leader>fk", function() Snacks.picker.keymaps() end, "Keymaps")
keymap('n', "<leader>fL", function() Snacks.picker.loclist() end, "Location List")
keymap('n', "<leader>fm", function() Snacks.picker.marks() end, "Marks")
keymap('n', "<leader>fM", function() Snacks.picker.man() end, "Man Pages")
keymap('n', "<leader>fq", function() Snacks.picker.qflist() end, "Quickfix List")
keymap('n', "<leader>;", function() Snacks.picker.resume() end, "Resume")
keymap('n', "<leader>fu", function() Snacks.picker.undo() end, "Undo History")
keymap('n', "<leader>fI", function() Snacks.picker.colorschemes() end, "Colorschemes")
-- lsp
keymap('n', "gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
keymap('n', "gD", function() Snacks.picker.lsp_declarations() end, "Goto Declaration")
keymap('n', "gr", function() Snacks.picker.lsp_references() end, "References", { nowait = true })
keymap('n', "gI", function() Snacks.picker.lsp_implementations() end, "Goto Implementation")
keymap('n', "gt", function() Snacks.picker.lsp_type_definitions() end, "Goto Type Definition")
keymap('n', "gi", function() Snacks.picker.lsp_incoming_calls() end, "Incoming Calls")
keymap('n', "go", function() Snacks.picker.lsp_outgoing_calls() end, "Outgoing Calls")
keymap('n', "gs", function() Snacks.picker.lsp_symbols() end, "LSP Symbols")
keymap('n', "gS", function() Snacks.picker.lsp_workspace_symbols() end, "LSP Workspace Symbols")
-- other
keymap('n', "<leader>.",  function() Snacks.scratch() end, "Toggle Scratch Buffer")
keymap('n', "<leader>fs",  function() Snacks.scratch.select() end, "Select Scratch Buffer")
keymap('n', "<leader>n", function()
  Snacks.win({
    file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
    width = 0.6,
    height = 0.6,
    wo = {
      spell = false,
      wrap = false,
      signcolumn = "yes",
      statuscolumn = " ",
      conceallevel = 3,
    },
  })
end, "Neovim News")

return M
