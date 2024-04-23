return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("fzf-lua").setup({
        fzf_opts = {
          ['--cycle'] = '',
        },
        winopts = {
          border = 'single',
        },
      })
      vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "FloatBorder" })
    end
  },
}
