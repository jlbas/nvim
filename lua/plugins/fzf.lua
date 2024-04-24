return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("fzf-lua").setup({
        fzf_opts = {
          ['--cycle'] = '',
        },
        args = { actions = { ["ctrl-x"] = false } },
        buffers = { actions = { ["ctrl-x"] = false } },
        git = {
          stash = { actions = { ["ctrl-x"] = false } },
          branches = { actions = { ["ctrl-x"] = false } },
          status = { actions = { ["ctrl-x"] = false } },
        },
        keymap = {
          builtin = {
            ["<C-d>"] = "preview-page-down",
            ["<C-u>"] = "preview-page-up",
          },
          fzf = {
            ["ctrl-d"] = "preview-page-down",
            ["ctrl-u"] = "preview-page-up",
          },
        },
        previewers = {
          builtin = {
            syntax_limit_b = 2048*2048,
          },
        },
        tabs = { actions = { ["ctrl-x"] = false } },
        winopts = {
          border = 'single',
        },
      })
      vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "FloatBorder" })
    end
  },
}
