return {
  -- { 'folke/neodev.nvim', opts = {} },
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require('lspconfig')
      lspconfig.clangd.setup {}
      lspconfig.pyright.setup {}
      lspconfig.lua_ls.setup({
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
              Lua = {
                runtime = {
                  version = 'LuaJIT'
                },
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME
                  }
                }
              }
            })

            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
          end
          return true
        end
      })

      vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist)

      vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
          underline = false,
          virtual_text = false,
        }
      )

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<leader>li', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>lk', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set({ 'n', 'x' }, '<leader>lf', vim.lsp.buf.format, opts)
        end,
      })
    end,
  },
}
