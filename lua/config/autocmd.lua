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
    if vim.bo.filetype == 'fzf' then return end
    vim.wo.number = true
    vim.wo.relativenumber = true
    vim.wo.signcolumn = "yes:1"
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'fzf',
  callback = function()
    pcall(vim.cmd, 'tunmap <buffer> <C-[><C-[>')
    vim.keymap.set('t', '<C-,>', function()
      vim.fn.chansend(vim.b.terminal_job_id, '\x0f')
    end, { buffer = true })
  end
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
