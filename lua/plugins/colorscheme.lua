vim.pack.add({'https://github.com/miikanissi/modus-themes.nvim'})

require('modus-themes').setup({
  style = "auto",
  variant = "default",
  transparent = false,
  dim_inactive = false,
  hide_inactive_statusline = false,
  line_nr_column_background = true,
  sign_column_background = false,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
  },

  on_colors = function(c)
    c.bg_main = nil
    c.bg_active = c.bg_dim
    c.bg_dim = c.bg_alt
    c.bg_status_line_active = c.bg_alt
    c.bg_status_line_inactive = c.bg_alt
    c.border= "#444444"
    c.border_highlight = "#646464"
    c.visual = "#545490"
    vim.g.terminal_color_8 = c.fg_dim
  end,

  on_highlights = function(hl, c)
    hl.CmpItemAbbrMatch           = { fg = c.magenta_cooler        }
    hl.CmpItemAbbrMatchFuzzy      = { fg = c.magenta_cooler        }
    hl.CursorLineNr               = { bg = c.bg_alt                }
    hl.LineNr                     = { fg = c.fg_dim                }
    hl.LineNrAbove                = { fg = c.fg_dim                }
    hl.LineNrBelow                = { fg = c.fg_dim                }
    hl.FloatBorder                = { fg = c.border, bg = c.bg_alt }
    hl.FloatTitle                 = { fg = c.fg_dim, bg = c.bg_alt }
    hl.PmenuSel                   = { bg = c.bg_hl_line            }
    hl.PmenuThumb                 = { bg = c.magenta_cooler        }
    hl.SnacksPicker               = { bg = c.bg_alt                }
    hl.SnacksPickerMatch          = { link = "Visual"              }
    hl.qfFileName                 = { fg = c.blue_faint            }
  end,
})

vim.cmd.colorscheme('modus_vivendi')
