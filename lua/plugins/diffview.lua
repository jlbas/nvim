vim.pack.add({'https://github.com/sindrets/diffview.nvim'})

require('diffview').setup({
  enhanced_diff_hl = true,
  hooks = {
    view_closed = function()
      if vim.fn.bufname('%') == '' and vim.fn.bufnr('%') == 1 then
        vim.cmd('quit')
      end
    end,
  }
})
