vim.pack.add({'https://github.com/miikanissi/modus-themes.nvim'})

require('modus-themes').setup({
  style = "auto",
  variant = "default",
  transparent = false,
  dim_inactive = false,
  hide_inactive_statusline = false,
  line_nr_column_background = true,
  sign_column_background = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
  },

  on_colors = function (colors)
    colors.bg_status_line_active = colors.bg_alt
    vim.g.terminal_color_8 = colors.fg_dim
  end,

  on_highlights = function(hl, color)
    hl.CursorLineNr       = { bg = color.bg_hl_line, bold = true             }
    hl.CursorLineSign     = { bg = color.bg_hl_line                          }
    hl.DiffAdd            = { bg = color.bg_added_faint                      }
    hl.DiffChange         = { bg = color.bg_changed_faint                    }
    hl.DiffDelete         = { bg = color.bg_removed_faint                    }
    hl.DiffText           = { bg = color.bg_changed_faint                    }
    hl.FloatBorder        = { fg = color.indigo, bg = color.bg_alt           }
    hl.FloatTitle         = { fg = color.indigo, bg = color.bg_alt           }
    hl.GitSignsAdd        = { fg = color.fg_added, bg = nil                  }
    hl.GitSignsChange     = { fg = color.fg_changed, bg = nil                }
    hl.GitSignsDelete     = { fg = color.fg_removed, bg = nil                }
    hl.LineNr             = { fg = color.fg_dim, bg = color.bg_alt           }
    hl.LineNrAbove        = { fg = color.fg_dim, bg = color.bg_alt           }
    hl.LineNrBelow        = { fg = color.fg_dim, bg = color.bg_alt           }
    hl.NormalFloat        = { bg = color.bg_alt                              }
    hl.Pmenu              = { fg = color.indigo, bg = color.bg_alt           }
    hl.PmenuSbar          = { fg = color.indigo, bg = color.bg_alt           }
    hl.PmenuSel           = { bg = color.visual                              }
    hl.PmenuThumb         = { fg = color.bg_alt, bg = color.indigo           }
    hl.SignColumn         = { bg = color.bg_alt                              }
    hl.SnacksPicker       = { bg = color.bg_alt                              }
    hl.WinSeparator       = { fg = "#444444", bold = true                    }
  end,
})

vim.cmd.colorscheme('modus_vivendi')
