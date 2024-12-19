return {
  -- {
  --   'catppuccin/nvim',
  --   name = 'catppuccin',
  --   opts = {
  --     term_colors = true,
  --     color_overrides = {
  --       mocha = {
  --         base = '#000000',
  --         mantle = '#000000',
  --         crust = '#000000',
  --       },
  --     },
  --   },
  -- },
  -- {
  --   'dasupradyumna/midnight.nvim',
  -- },
  {
    'EdenEast/nightfox.nvim',
    enabled = false,
    config = function()
      local C = require('nightfox.lib.color')
      local bg = C('#000000')
      local palette = require('nightfox.palette').load('carbonfox')
      local group = require('nightfox.group').load('carbonfox')
      require('nightfox').setup({
        palettes = {
          carbonfox = {
            bg0 = bg:brighten(10):to_css(),
            bg1 = bg:to_css(),
            bg2 = bg:brighten(10):to_css(),
            bg3 = bg:brighten(6):to_css(),
            bg4 = bg:brighten(24):to_css(),
          },
        },
        groups = {
          carbonfox = {
            -- WinSeparator = { fg = bg:brighten(24):to_css() },
            -- DapBreakpoint = { fg = palette.red },
            -- DapStoppedText = { fg = palette.magenta },
            -- DapStoppedLine = { bg = group.DiagnosticVirtualTextWarn.bg },
            -- LspSignatureActiveParameter = { fg = palette.magenta, style = "italic,bold" },
            DiagnosticVirtualTextError = { bg = "none" },
            DiagnosticVirtualTextWarn = { bg = "none" },
            DiagnosticVirtualTextInfo = { bg = "none" },
            DiagnosticVirtualTextHint = { bg = "none" },
            DiagnosticVirtualTextOk = { bg = "none" },
          }
        }
      })
    end,
    init = function()
      vim.cmd.colorscheme 'carbonfox'
    end,
  },
  -- {
  --   'ellisonleao/gruvbox.nvim',
  --   opts = {
  --     overrides = {
  --       Normal = { bg = '#000000' },
  --     },
  --   },
  -- },
  -- {
  --   'folke/tokyonight.nvim',
  --   opts = {
  --     style = 'night',
  --     on_colors = function(colors)
  --       colors.bg_dark = '#000000'
  --       colors.bg= '#000000'
  --     end,
  --   },
  -- },
  -- {
  --   'marko-cerovac/material.nvim',
  --   opts = {
  --     custom_highlights = {
  --       Normal = { bg = '#000000' },
  --     },
  --   },
  -- },
  {
    'miikanissi/modus-themes.nvim',
    enabled = true,
    init = function()
      vim.cmd.colorscheme('modus_vivendi')
    end,
    opts = {
      on_colors = function (colors)
        colors.bg_status_line_active = colors.bg_alt
      end,
      on_highlights = function(highlight, color)
        highlight.CursorLineNr   = { bg = color.bg_hl_line, bold = true }
        highlight.DiffAdd        = { bg = color.bg_added_faint          }
        highlight.DiffChange     = { bg = color.bg_changed_faint        }
        highlight.DiffDelete     = { bg = color.bg_removed_faint        }
        highlight.DiffText       = { bg = color.bg_changed_faint        }
        highlight.GitSignsAdd    = { fg = color.fg_added, bg = nil      }
        highlight.GitSignsChange = { fg = color.fg_changed, bg = nil    }
        highlight.GitSignsDelete = { fg = color.fg_removed, bg = nil    }
        highlight.LineNr         = { fg = color.fg_dim, bg = nil        }
        highlight.LineNrAbove    = { fg = color.fg_dim, bg = nil        }
        highlight.LineNrBelow    = { fg = color.fg_dim, bg = nil        }
        highlight.WinSeparator   = { fg = color.border, bg = nil        }
      end,
    },
    priority = 1000,
  },
  -- {
  --   'Mofiqul/vscode.nvim',
  --   opts = {
  --     group_overrides = {
  --       Normal = { bg = '#000000', },
  --     },
  --   },
  -- },
  -- {
  --   'navarasu/onedark.nvim',
  --   opts = {
  --     style = 'dark',
  --     highlights = {
  --       Normal = { bg = '#000000' },
  --     },
  --   },
  -- },
  -- {
  --   'projekt0n/github-nvim-theme',
  --   name = 'github-theme',
  --   opts = {
  --     groups = {
  --       github_dark = {
  --         Normal = { bg = '#000000' },
  --       },
  --     },
  --   },
  -- },
  -- {
  --   'rebelot/kanagawa.nvim',
  --   name = 'kanagawa',
  --   opts = {
  --     overrides = function(colors)
  --       return {
  --         Normal = { bg = '#000000' }
  --       }
  --     end,
  --   },
  -- },
  -- {
  --   'rose-pine/neovim',
  --   name = 'rose-pine',
  --   opts = {
  --     highlight_groups = {
  --       Normal = { bg = '#000000' },
  --     },
  --   },
  -- },
  -- {
  --   'srcery-colors/srcery-vim',
  --   init = function()
  --     vim.g.srcery_bg = { '#000000', 0 }
  --   end,
  -- },
}
