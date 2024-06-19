vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  callback = function()
    if vim.bo.buftype == 'quickfix' and vim.fn.winbufnr(2) == -1 then
      vim.cmd('quit!')
    end
  end
})

vim.api.nvim_create_autocmd({ 'TermEnter', 'TermOpen' }, {
  pattern = 'term://*',
  command = 'startinsert',
})

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = 'term://*',
  command = 'tnoremap <ESC><ESC> <C-\\><C-n>'
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'fzf',
  command = 'tunmap <ESC><ESC>'
})
})

vim.cmd([[
  command! -bang -nargs=* Rgf call fzf#vim#grep('
  \ rg --column --line-number --no-heading --fixed-strings --color=always --smart-case
  \ '.shellescape(<q-args>), 1, <bang>0)
]])
