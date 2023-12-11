return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    opts = {
      term_colors = true,
      color_overrides = {
        mocha = {
          base = '#000000', 
          mantle = '#000000', 
          crust = '#000000', 
        },
      },
    },
  },
  {
    'dasupradyumna/midnight.nvim',
  },
  {
    'EdenEast/nightfox.nvim',
    opts = {
      palettes = {
        carbonfox = { bg1 = '#000000' },
        nightfox = { bg1 = '#000000' },
      },
    },
    init = function()
      vim.cmd.colorscheme 'carbonfox'
    end,
  },
  {
    'ellisonleao/gruvbox.nvim',
    opts = {
      overrides = {
        Normal = { bg = '#000000' },
      },
    },
  },
  {
    'folke/tokyonight.nvim',
    opts = {
      style = 'night',
      on_colors = function(colors)
        colors.bg_dark = '#000000'
        colors.bg= '#000000'
      end,
    },
  },
  {
    'marko-cerovac/material.nvim',
    opts = {
      custom_highlights = {
        Normal = { bg = '#000000' },
      },
    },
  },
  {
    'miikanissi/modus-themes.nvim',
  },
  {
    'Mofiqul/vscode.nvim',
    opts = {
      group_overrides = {
        Normal = { bg = '#000000', },
      },
    },
  },
  {
    'navarasu/onedark.nvim',
    opts = {
      style = 'dark',
      highlights = {
        Normal = { bg = '#000000' },
      },
    },
  },
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    opts = {
      groups = {
        github_dark = {
          Normal = { bg = '#000000' },
        },
      },
    },
  },
  {
    'rebelot/kanagawa.nvim',
    name = 'kanagawa',
    opts = {
      overrides = function(colors)
        return {
          Normal = { bg = '#000000' }
        }
      end,
    },
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    opts = {
      highlight_groups = {
        Normal = { bg = '#000000' },
      },
    },
  },
  {
    'srcery-colors/srcery-vim',
    init = function()
      vim.g.srcery_bg = { '#000000', 0 }
    end,
  },
}
