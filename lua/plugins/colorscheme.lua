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
    hl.CmpItemAbbrMatch      = { fg = color.magenta_cooler, bg = color.bg_alt                }
    hl.CmpItemAbbrMatchFuzzy = { fg = color.magenta_cooler, bg = color.bg_alt                }
    hl.CursorLineNr          = { bg = color.bg_hl_line, bold = true                          }
    hl.CursorLineSign        = { bg = color.bg_hl_line                                       }
    hl.DiffAdd               = { bg = color.bg_added_faint                                   }
    hl.DiffChange            = { bg = color.bg_changed_faint                                 }
    hl.DiffDelete            = { bg = color.bg_removed_faint                                 }
    hl.DiffText              = { bg = color.bg_changed_faint                                 }
    hl.FloatBorder           = { fg = color.magenta_cooler, bg = color.bg_alt                }
    hl.FloatTitle            = { fg = color.magenta_cooler, bg = color.bg_alt                }
    hl.GitSignsAdd           = { fg = color.fg_added, bg = nil                               }
    hl.GitSignsChange        = { fg = color.fg_changed, bg = nil                             }
    hl.GitSignsDelete        = { fg = color.fg_removed, bg = nil                             }
    hl.GitSignsAddInline     = { fg = color.fg_added_intense, bg = color.bg_added_refine     }
    hl.GitSignsChangeInline  = { fg = color.fg_changed_intense, bg = color.bg_changed_refine }
    hl.GitSignsDeleteInline  = { fg = color.fg_removed_intense, bg = color.bg_removed_refine }
    hl.LineNr                = { fg = color.fg_dim, bg = color.bg_alt                        }
    hl.LineNrAbove           = { fg = color.fg_dim, bg = color.bg_alt                        }
    hl.LineNrBelow           = { fg = color.fg_dim, bg = color.bg_alt                        }
    hl.NormalFloat           = { bg = color.bg_dim                                           }
    hl.Pmenu                 = { fg = color.magenta_cooler, bg = color.bg_dim                }
    hl.PmenuSbar             = { fg = color.magenta_cooler, bg = color.bg_dim                }
    hl.PmenuSel              = { bg = color.bg_hl_line                                       }
    hl.PmenuThumb            = { fg = color.bg_dim, bg = color.magenta_cooler                }
    hl.QuickFixLine          = { fg = color.fg_main, bg = color.magenta_subtle               }
    hl.SignColumn            = { bg = color.bg_alt                                           }
    hl.SnacksPicker          = { bg = color.bg_alt                                           }
    hl.SnacksPickerMatch     = { fg = color.magenta_cooler                                   }
    hl.WinSeparator          = { fg = color.border, bold = true                              }
  end,
})

vim.cmd.colorscheme('modus_vivendi')
