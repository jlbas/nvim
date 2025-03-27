vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  callback = function()
    if vim.bo.buftype == 'quickfix' and vim.fn.winbufnr(2) == -1 then
      vim.cmd('quit!')
    end
  end
})

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = 'term://*',
  callback = function()
    vim.wo.number = true
    vim.wo.relativenumber = true
    vim.wo.signcolumn = "yes:1"
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'fzf',
  callback = function()
    vim.cmd.tunmap('<buffer>', '<ESC><ESC>')
    vim.cmd.tnoremap('<buffer>', '<ESC>', '<C-c>')
  end
})

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  callback = function()
    for _, arg in ipairs(vim.v.argv) do
      if arg == '+Man!' then
        return
      end
    end

    local base_dir = vim.system({ 'git', 'remote', 'get-url', 'origin' }, { text = true }):wait()
    if base_dir.code ~= 128 and base_dir.stdout:find('panos') then
      local branch = vim.system({ 'git', 'branch', '--show-current' }):wait().stdout:gsub('\n', '')
      local file = vim.fn.expand('~/.local/state/nvim/session/' .. branch .. '.vim')
      if vim.fn.filereadable(file) == 0 then
        print('Creating new session for ' .. branch .. ' workspace')
        vim.cmd.mksession({ file, bang = true })
      elseif vim.fn.argc() == 0 then
        vim.cmd.source(file)
      end
    end
  end,
  nested = true,
})

vim.api.nvim_create_autocmd({ 'VimResized' }, {
  callback = function()
    vim.cmd('wincmd =')
  end
})

vim.api.nvim_create_autocmd({ 'BufWritePre', 'VimLeave' }, {
  callback = function()
    if vim.v.this_session ~= '' then
      vim.cmd.mksession({ vim.v.this_session, bang = true })
    end
  end
})

vim.cmd([[
  command! -bang -nargs=* Rgf call fzf#vim#grep('
  \ rg --column --line-number --no-heading --fixed-strings --color=always --smart-case
  \ '.shellescape(<q-args>), 1, <bang>0)
]])

vim.api.nvim_create_user_command('Rmsession', function()
  if vim.v.this_session ~= '' then
    vim.cmd('!rm ' .. vim.v.this_session)
    vim.v.this_session = ''
  end
end, {})

vim.api.nvim_create_user_command('CloseFugitiveTabs', function()
  for tabnr = vim.fn.tabpagenr('$'), 1, -1 do
    local buflist = vim.fn.tabpagebuflist(tabnr)
    if #buflist == 2 then
      local bnames = { vim.fn.bufname(buflist[1]), vim.fn.bufname(buflist[2]) }
      if (bnames[1]:match('^fugitive://') and bnames[1]:find(bnames[2])) or (bnames[2]:match('^fugitive://') and bnames[2]:find(bnames[1])) then
        vim.cmd('tabclose ' .. tabnr)
      end
    end
  end
end, {})
