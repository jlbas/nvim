vim.pack.add({
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/neovim/nvim-lspconfig',
})

require('mason').setup()

require('mason-lspconfig').setup({
  automatic_installation = true,
  automatic_enable = false,
  ensure_installed = {},
})

require('fidget').setup({})

local lsp_servers = {
  bashls = { filetypes = { 'sh', 'bash', 'zsh' } },
  buf_ls = { filetypes = { 'proto' } },
  clangd = { filetypes = { 'c', 'cpp', 'objc', 'objcpp' } },
  cmake = { filetypes = { 'cmake' } },
  dockerls = { filetypes = { 'dockerfile' } },
  docker_compose_language_service = { filetypes = { 'yaml' } },
  lua_ls = { filetypes = { 'lua' } },
  marksman = { filetypes = { 'markdown' } },
  perlnavigator = { filetypes = { 'perl' } },
  -- protols = { filetypes = { 'proto' } },
  pyright = { filetypes = { 'python' } },
  vimls = { filetypes = { 'vim' } },
}

for lsp_name, cfg in pairs(lsp_servers) do
  if IS_WORK and lsp_name == 'clangd' then
    local cmd = {
      "clangd",
      "--header-insertion=never",
      "--background-index",
      "--background-index-priority=background",
      "--log=error",
      -- "--limit-results=20",
      -- "--limit-references=20",
      -- "-j=10",
      "--clang-tidy",
      -- "--malloc-trim",
      -- "--pch-storage=memory",
    }
    local url = vim.system({ 'git', 'remote', 'get-url', 'origin' }, { text = true }):wait()
    if url.code ~= 128 and url.stdout == 'ssh://git@gitpanos.mv.usa.alcatel.com/sr/srlinux.git\n' then
      table.insert(cmd, '--compile-commands-dir=build/amd64/debug/')
    end
    cfg.cmd = cmd
    cfg.capabilities = { offsetEncoding = { "utf-16" } }
    cfg.on_error = function(code, err)
      print("vim.lsp.rpc.client_errors[code]=", vim.lsp.rpc.client_errors[code])
      print("err=", err)
    end
    cfg.on_exit = vim.schedule_wrap(function(code, signal, client_id)
      print("code=", code)
      print("signal=", signal)
      print("client_id=", client_id)
      if code == 0 and signal == 11 then
        print("Restarting lsp!")
        vim.cmd('LspStart')
      end
    end)
  end
  cfg.capabilities = vim.tbl_extend('keep', cfg.capabilities or {}, require('blink.cmp').get_lsp_capabilities())
  vim.lsp.config[lsp_name] = cfg
  vim.lsp.enable(lsp_name)
end

vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end)
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end)
vim.keymap.set('n', '[D', function() vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR }) end)
vim.keymap.set('n', ']D', function() vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR }) end)
vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist)

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
    }
  },
  underline = false,
  virtual_text = false,
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

local border = {
  { '┌', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '┐', 'FloatBorder' },
  { '│', 'FloatBorder' },
  { '┘', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '└', 'FloatBorder' },
  { '│', 'FloatBorder' },
}

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
