return {
  {
    'saghen/blink.cmp',
    lazy = false,
    dependencies = {
      'rafamadriz/friendly-snippets',
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      }
    },
    version = 'v0.*',
    opts = {
      keymap = {
        preset = 'default',
      },
      appearance = {
        use_nvim_cmp_as_default = true,
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
      },
      providers = {
        lsp = { fallback_for = { 'lazydev' } },
        lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink' },
      },
      signature = { enabled = true }
    },
  },
}
