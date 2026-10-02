local keymap = vim.keymap.set

-- Autocmds --------------------------------------------------------------------

-- Each buffer gets its own working directory (:bcd), resolved once on first enter
local function set_buf_cwd(buf, dir)
  if not vim.api.nvim_buf_is_valid(buf) then return end
  vim.b[buf].work_cwd = dir
  vim.api.nvim_buf_call(buf, function() vim.cmd.bcd(vim.fn.fnameescape(dir)) end)
end

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  callback = function(ev)
    if vim.b[ev.buf].work_cwd then return end
    local name = vim.api.nvim_buf_get_name(ev.buf)
    if name:find('/home/bastarac/onedrive/panos') and not name:find('/home/bastarac/onedrive/panos/panos') then
      set_buf_cwd(ev.buf, '/home/bastarac/onedrive/panos/panos')
    end
  end
})

local git_root_cache = {}
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  callback = function(ev)
    local buf = ev.buf
    if vim.b[buf].work_cwd then return end
    local name = vim.api.nvim_buf_get_name(buf)
    local dir = vim.fs.dirname(name)
    if dir == '' or dir == '.' then return end

    if git_root_cache[dir] ~= nil then
      set_buf_cwd(buf, git_root_cache[dir])
      return
    end

    vim.system({ 'git', '-C', dir, 'rev-parse', '--show-toplevel' }, { text = true }, function(result)
      vim.schedule(function()
        if result.code == 0 then
          local root = result.stdout:gsub('\n', '')
          git_root_cache[dir] = root
          set_buf_cwd(buf, root)
        else
          local base_dirs = { '/home/bastarac/onedrive' }
          for _, base in pairs(base_dirs) do
            if name:find(base) then
              git_root_cache[dir] = base
              set_buf_cwd(buf, base)
            end
          end
        end
      end)
    end)
  end
})

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  callback = function()
    for _, arg in ipairs(vim.v.argv) do
      if arg == '+Man!' or arg == 'packadd nvim.difftool' then
        return
      end
    end

    vim.system({ 'git', 'remote', 'get-url', 'origin' }, { text = true }, function(base_dir)
      if base_dir.code ~= 128 and base_dir.stdout:find('panos') then
        vim.system({ 'git', 'branch', '--show-current' }, { text = true }, function(branch_result)
          vim.schedule(function()
            local branch = branch_result.stdout:gsub('\n', '')
            local file = vim.fn.expand('~/.local/state/nvim/session/' .. branch .. '.vim')
            if vim.fn.filereadable(file) == 0 then
              print('Creating new session for ' .. branch .. ' workspace')
              vim.cmd.mksession({ file, bang = true })
            elseif vim.fn.argc() == 0 then
              vim.cmd.source(file)
            end
          end)
        end)
      end
    end)
  end,
  nested = true,
})

-- Commands --------------------------------------------------------------------

vim.api.nvim_create_user_command('Rmsession', function()
  if vim.v.this_session ~= '' then
    vim.cmd('!rm ' .. vim.v.this_session)
    vim.v.this_session = ''
  end
end, {})

-- Keymaps ---------------------------------------------------------------------

keymap('n', 'gdd', function()
  local line = vim.api.nvim_get_current_line()
  local marker = '// DO_NOT_COMMIT'
  if line:find(marker, 1, true) then
    local new_line = line:gsub('%s*' .. marker .. ".*$", "")
    vim.api.nvim_set_current_line(new_line)
  else
    vim.api.nvim_set_current_line(line:gsub('%s*$', '') .. ' ' .. marker)
  end
end, { desc = 'Toggle DO_NOT_COMMIT comment' })

local function fzf_notes()
  require('fzf-lua').files({ cwd = '~/OneDrive/notes/' })
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

keymap('n', '<leader>fn', fzf_notes, { desc = 'Find notes' })
keymap('n', '<leader>nn', function() open_ws_notes() end, { desc = 'Open workspace notes' })
keymap('n', '<leader>n<CR>', function() open_ws_notes() end, { desc = 'Open workspace notes' })
keymap('n', '<leader>ns', function() open_ws_notes('split') end, { desc = 'Open workspace notes in split' })
keymap('n', '<leader>nv', function() open_ws_notes('vsplit') end, { desc = 'Open workspace notes in vsplit' })
keymap('n', '<leader>nt', function() open_ws_notes('tabedit') end, { desc = 'Open workspace notes in tab' })

-- LSP (clangd) ----------------------------------------------------------------

local cfg = vim.lsp.config.clangd
cfg.cmd = {
  "clangd",
  "--header-insertion=never",
  "--background-index",
  "--background-index-priority=background",
  "--log=error",
  "--clang-tidy",
}
cfg.capabilities = vim.tbl_extend('keep', { offsetEncoding = { "utf-16" } }, cfg.capabilities or {})
cfg.on_error = function(code, err)
  print("vim.lsp.rpc.client_errors[code]=", vim.lsp.rpc.client_errors[code])
  print("err=", err)
end
cfg.on_exit = vim.schedule_wrap(function(code, signal, client_id)
  print("code=", code)
  print("signal=", signal)
  print("client_id=", client_id)
  if code == 0 and signal == 11 then
    print("Restarting lsp!")
    vim.cmd('LspStart')
  end
end)
vim.lsp.config.clangd = cfg
