return {
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      enhanced_diff_hl = true,
      hooks = {
        view_closed = function()
          if vim.fn.bufname('%') == '' and vim.fn.bufnr('%') == 1 then
            vim.cmd('quit')
          end
        end,
      }
    },
  },
}
