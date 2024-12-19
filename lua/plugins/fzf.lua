return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local fzf_lua = require('fzf-lua')
      local actions = fzf_lua.actions
      local nvim_window = require('nvim-window')

      function actions.pick_window(selected, opts)
        local last_win = vim.fn.win_getid()
        nvim_window.pick()
        if vim.fn.win_getid() ~= last_win then
          if selected[1]:sub(1,1) == '[' then
            actions.buf_edit(selected, opts)
          else
            actions.file_edit(selected, opts)
          end
        end
      end

      fzf_lua.defaults.buffers.actions["ctrl-q"] = actions.pick_window
      fzf_lua.defaults.actions.files["ctrl-q"] = actions.pick_window

      fzf_lua.setup({
        fzf_opts = { ['--cycle'] = '' },
        args = { actions = { ["ctrl-x"] = false } },
        git = {
          stash = { actions = { ["ctrl-x"] = false } },
          branches = { actions = { ["ctrl-x"] = false } },
          status = { actions = { ["ctrl-x"] = false } },
        },
        keymap = {
          builtin = {
            ["<C-f>"] = "preview-page-down",
            ["<C-b>"] = "preview-page-up",
          },
          fzf = {
            ["ctrl-f"] = "preview-page-down",
            ["ctrl-b"] = "preview-page-up",
          },
        },
        previewers = { builtin = { syntax_limit_b = 2048*2048 } },
        winopts = { border = 'single' },
      })
      vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "FloatBorder" })
    end
  },
}
