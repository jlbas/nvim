return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local actions = require('fzf-lua.actions')

      function actions.file_pick_window(selected, opts)
        require('nvim-window').pick()
        actions.file_edit(selected, opts)
      end

      function actions.buf_pick_window(selected, opts)
        require('nvim-window').pick()
        actions.buf_edit(selected, opts)
      end

      require("fzf-lua").setup({
        fzf_opts = {
          ['--cycle'] = '',
        },
        args = { actions = { ["ctrl-x"] = false } },
        buffers = {
          actions = {
            ["ctrl-x"] = false,
            ["ctrl-o"] = actions.buf_pick_window,
          },
        },
        git = {
          stash = { actions = { ["ctrl-x"] = false } },
          branches = { actions = { ["ctrl-x"] = false } },
          status = { actions = { ["ctrl-x"] = false } },
        },
        files = { actions = { ["ctrl-o"] = actions.file_pick_window } },
        keymap = {
          builtin = {
            ["ctrl-d"] = "preview-page-down",
            ["ctrl-u"] = "preview-page-up",
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
