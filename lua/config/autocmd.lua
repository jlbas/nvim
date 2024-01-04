vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  callback = function()
    if vim.bo.buftype == 'quickfix' and vim.fn.winbufnr(2) == -1 then
      vim.cmd('quit!')
    end
  end
})

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  pattern = { '*onedrive/*' },
  callback = function()
    io.popen('odpush')
  end
})
