local M = {}

function M.feedkeys(keys, replace_termcodes)
  if replace_termcodes then
    keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  end
  vim.api.nvim_feedkeys(keys, 'n', true)
end

function M.get_selected_text()
  local old_reg = vim.fn.getreg('"')
  local old_reg_type = vim.fn.getregtype('"')
  vim.cmd('norm gvy')
  local ret = vim.fn.getreg('"')
  vim.fn.setreg('"', old_reg, old_reg_type)
  vim.cmd([[norm \<ESC>]])
  return tostring(ret)
end

function M.pick_win()
  vim.api.nvim_set_hl(0, 'WinPickLabel', { link = 'IncSearch' })
  local wins = vim.tbl_filter(function(w)
    return vim.api.nvim_win_get_config(w).relative == ''
  end, vim.api.nvim_tabpage_list_wins(0))
  if #wins <= 1 then return nil end
  if #wins == 2 then
    for _, w in ipairs(wins) do
      if w ~= vim.api.nvim_get_current_win() then return w end
    end
  end
  local labels = 'abcdefghijklmnopqrstuvwxyz'
  local floats = {}
  for i, win in ipairs(wins) do
    local char = labels:sub(i, i)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { ' ' .. char:upper() .. ' ' })
    local width = vim.api.nvim_win_get_width(win)
    local height = vim.api.nvim_win_get_height(win)
    local float = vim.api.nvim_open_win(buf, false, {
      relative = 'win',
      win = win,
      row = math.floor(height / 2),
      col = math.floor(width / 2) - 1,
      width = 3,
      height = 1,
      style = 'minimal',
      border = 'rounded',
      focusable = false,
      zindex = 100,
    })
    vim.api.nvim_win_set_option(float, 'winhighlight', 'Normal:WinPickLabel,FloatBorder:WinPickLabel')
    table.insert(floats, { float = float, buf = buf, win = win, char = char })
  end
  vim.cmd('redraw')
  local ok, char = pcall(vim.fn.getcharstr)
  for _, f in ipairs(floats) do
    vim.api.nvim_win_close(f.float, true)
    vim.api.nvim_buf_delete(f.buf, { force = true })
  end
  if not ok then return nil end
  for _, f in ipairs(floats) do
    if f.char == char:lower() then return f.win end
  end
  return nil
end

local hidden_terms = {}

function M.toggle_terms()
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
    if vim.bo[buf].buftype == 'terminal' then
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
end

return M
