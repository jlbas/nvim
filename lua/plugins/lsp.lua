-- HACK: Neovim maps these methods to themselves instead of their parent capability,
-- causing supports_method() to return false. Upstream LSP spec fix merged
-- (microsoft/vscode-languageserver-node#1720) but not yet in Neovim.
-- Remove once neovim/neovim#37696 is resolved.
vim.lsp.protocol._request_name_to_server_capability['callHierarchy/incomingCalls'] = { 'callHierarchyProvider' }
vim.lsp.protocol._request_name_to_server_capability['callHierarchy/outgoingCalls'] = { 'callHierarchyProvider' }
vim.lsp.protocol._request_name_to_server_capability['typeHierarchy/subtypes'] = { 'typeHierarchyProvider' }
vim.lsp.protocol._request_name_to_server_capability['typeHierarchy/supertypes'] = { 'typeHierarchyProvider' }

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
  docker_compose_language_service = { filetypes = { 'yaml.docker-compose' } },
  lua_ls = { filetypes = { 'lua' } },
  marksman = { filetypes = { 'markdown' } },
  perlnavigator = { filetypes = { 'perl' } },
  -- protols = { filetypes = { 'proto' } },
  pyright = { filetypes = { 'python' } },
  vimls = { filetypes = { 'vim' } },
}

for lsp_name, cfg in pairs(lsp_servers) do
  cfg.capabilities = vim.tbl_extend('keep', cfg.capabilities or {}, require('blink.cmp').get_lsp_capabilities())
  vim.lsp.config[lsp_name] = cfg
  vim.lsp.enable(lsp_name)
end

vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float)

local function diag_jump(opts)
  vim.diagnostic.jump(vim.tbl_extend('keep', opts, {
    on_jump = vim.diagnostic.open_float,
  }))
end
vim.keymap.set('n', '[d', function() diag_jump({ count = -1 }) end)
vim.keymap.set('n', ']d', function() diag_jump({ count = 1 }) end)
vim.keymap.set('n', '[D', function() diag_jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end)
vim.keymap.set('n', ']D', function() diag_jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end)
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
    local opts = { buffer = ev.buf }
    vim.keymap.set({'n', 'x'}, '<leader>la', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
    vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set({'n', 'x'}, '<leader>lf', function()
      require('conform').format({ lsp_fallback = true })
    end, opts)
  end,
})
