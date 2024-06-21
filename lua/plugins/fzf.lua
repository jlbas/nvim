return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local actions = require('fzf-lua.actions')
      local default_actions = require('fzf-lua').defaults.actions
      local nvim_window = require('nvim-window')

      function actions.file_pick_window(selected, opts)
        nvim_window.pick()
        actions.file_edit(selected, opts)
      end

      function actions.buf_pick_window(selected, opts)
        local last_win = vim.fn.win_getid()
        nvim_window.pick()
        if vim.fn.win_getid() ~= last_win then
          actions.buf_edit(selected, opts)
        end
      end

      default_actions.buffers["ctrl-]"] = actions.buf_pick_window
      default_actions.files["ctrl-]"] = actions.file_pick_window

      require("fzf-lua").setup({
        fzf_opts = { ['--cycle'] = '' },
        args = { actions = { ["ctrl-x"] = false } },
        buffers = { actions = { ["ctrl-x"] = false } },
        git = {
          stash = { actions = { ["ctrl-x"] = false } },
          branches = { actions = { ["ctrl-x"] = false } },
          status = { actions = { ["ctrl-x"] = false } },
        },
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
        previewers = { builtin = { syntax_limit_b = 2048*2048 } },
        tabs = { actions = { ["ctrl-x"] = false } },
        winopts = { border = 'single' },
      })
      vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "FloatBorder" })
    end
  },
}
