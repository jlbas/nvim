return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'folke/neodev.nvim', opts = {} },
      { 'j-hui/fidget.nvim', opts = {} },
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      local lsp_servers = {
          'bashls',
          'clangd',
          'cmake',
          'dockerls',
          'docker_compose_language_service',
          'lua_ls',
          'marksman',
          'perlnavigator',
          'pyright',
          'vimls',
      }
      require('mason-lspconfig').setup({
        automatic_installation = true,
        ensure_installed = lsp_servers,
      })
      local lspconfig = require('lspconfig')
      for _, lsp in ipairs(lsp_servers) do
        if lsp == 'clangd' then
          lspconfig[lsp].setup({
            cmd = {
              "clangd",
              "--header-insertion=never",
              "--background-index",
              "--background-index-priority=background",
              -- "--log=verbose",
              "--limit-results=100",
              "-j=10",
              "--clang-tidy",
            },
            -- cmd = {
            --   "/usr/local/timostools/build/linux/llvm/14.0/bin/clangd",
            --   "--header-insertion=never",
            --   "--background-index",
            --   "--log=error",
            --   "--limit-results=100",
            --   "-j=10",
            -- },
            on_error = function()
              print("LSP Error!")
            end,
            on_exit = vim.schedule_wrap(function()
              print("Restarting lsp!")
              vim.cmd('LspStart')
            end),
          })
        else
          lspconfig[lsp].setup({})
        end
      end
      vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '[D', function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end)
      vim.keymap.set('n', ']D', function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end)
      vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist)

      vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
          signs = false,
          underline = false,
          virtual_text = {
            format = function()
              return ""
            end,
            spacing = 0,
          },
        }
      )
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
          border = "single",
          title = "Signature Help",
        }
      )
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
          border = "single",
          title = "Hover",
        }
      )

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, opts)
          vim.keymap.set('x', '<leader>la', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>lk', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'x' }, '<leader>lf', function()
            require('conform').format({ lsp_fallback = true })
          end, opts)
        end,
      })
    end,
  },
  {
    'stevearc/conform.nvim',
    config = function()
      local conform = require('conform')
      conform.setup({
        formatters_by_ft = {
          c = { 'clang_format' },
          cpp = { 'clang_format' },
          lua = { 'stylua' },
          markdown = { 'prettier' },
          python = { 'isort', 'black' },
        },
      })
      conform.formatters.black = {
        prepend_args = { '--line-length', '120' }
      }
      conform.formatters.clang_format = {
        prepend_args = { '-style', 'file:' .. vim.fn.expand("$HOME/.config/clangd/clang-format.yaml") },
      }
    end,
  },
  {
    'mfussenegger/nvim-lint',
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
      }
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
