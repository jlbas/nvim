return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      local lsp_servers = {
          'bashls',
          'buf_ls',
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
        local cfg = {}
        if lsp == 'clangd' then
          local cmd = {
            "clangd",
            "--header-insertion=never",
            "--background-index",
            "--background-index-priority=background",
            "--log=error",
            "--limit-results=20",
            "--limit-references=20",
            "-j=10",
            "--clang-tidy",
            "--malloc-trim",
            "--pch-storage=memory",
          }
          local url = vim.system({ 'git', 'remote', 'get-url', 'origin' }, { text = true }):wait()
          if url.code ~= 128 and url.stdout == 'ssh://git@gitpanos.mv.usa.alcatel.com/sr/srlinux.git\n' then
            table.insert(cmd, '--compile-commands-dir=build/debug/')
          end
          cfg = {
            cmd = cmd,
            capabilities = {
              offsetEncoding = { "utf-16" },
            },
            on_error = function(code, err)
              print("vim.lsp.rpc.client_errors[code]=", vim.lsp.rpc.client_errors[code])
              print("err=", err)
            end,
            on_exit = vim.schedule_wrap(function(code, signal, client_id)
              print("code=", code)
              print("signal=", signal)
              print("client_id=", client_id)
              if code == 0 and signal == 11 then
                print("Restarting lsp!")
                vim.cmd('LspStart')
              end
            end),
          }
        end
        cfg.capabilities = vim.tbl_extend('keep', cfg.capabilities or {}, require('blink.cmp').get_lsp_capabilities())
        lspconfig[lsp].setup(cfg)
      end
      vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end)
      vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end)
      vim.keymap.set('n', '[D', function() vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR }) end)
      vim.keymap.set('n', ']D', function() vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR }) end)
      vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist)

      vim.diagnostic.config({
        signs = false,
        underline = false,
        virtual_text = {
          format = function()
            return ""
          end,
          prefix = "● ",
          spacing = 1,
          virt_text_pos = "right_align",
        },
      })

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
          vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
          vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set({'n', 'x'}, '<leader>lf', function()
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
