return {
  {
    'saghen/blink.cmp',
    lazy = false,
    dependencies = 'rafamadriz/friendly-snippets',
    version = 'v0.*',
    opts = {
      keymap = {
        preset = 'default',
      },
      appearance = {
        use_nvim_cmp_as_default = true,
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      signature = { enabled = true }
    },
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'onsails/lspkind-nvim',
      'rafamadriz/friendly-snippets',
      'saadparwaiz1/cmp_luasnip',
      { 'zbirenbaum/copilot-cmp', opts = {} },
    },
    enabled = false,
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      cmp.setup({
        formatting = {
          format = require('lspkind').cmp_format({
            ellipsis_char = '',
            maxwidth = 50,
            menu = {
              buffer = '[buf]',
              cmdline = '[cmd]',
              copilot = '[cop]',
              luasnip = '[snip]',
              nvim_lsp = '[lsp]',
              nvim_lua = '[api]',
              path = '[path]',
            },
            mode = 'symbol',
            symbol_map = { Copilot = '' },
          }),
        },
        -- experimental = {
        --   ghost_text = true,
        -- },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        },
        performance = {
          debounce = 0,
          throttle = 0,
        },
        sources = {
          { name = 'copilot' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'nvim_lua' },
          { name = 'buffer' },
          { name = 'path' },
        },
      })
      -- cmp.setup.cmdline('/', {
      --   mapping = {
      --     cmp.mapping.preset.cmdline(),
      --   },
      --   sources = cmp.config.sources({
      --     { name = 'buffer' },
      --   }, {
      --     { name = 'cmdline_history' },
      --   }),
      -- })
      -- cmp.setup.cmdline(':', {
      --   mapping = {
      --     cmp.mapping.preset.cmdline(),
      --   },
      --   sources = cmp.config.sources({
      --     { name = 'path' },
      --   }, {
      --     { name = 'cmdline' },
      --   }, {
      --     { name = 'buffer' },
      --   }, {
      --     { name = 'cmdline_history' },
      --   }),
      -- })
      local ls = require('luasnip')
      vim.keymap.set({'i', 's'}, '<C-l>', function() ls.jump(1) end, {silent = true})
      vim.keymap.set({'i', 's'}, '<C-h>', function() ls.jump(-1) end, {silent = true})
      vim.keymap.set({'i', 's'}, '<C-e>', function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, {silent = true})
      require('luasnip.loaders.from_vscode').lazy_load()

    end,
  },
}
