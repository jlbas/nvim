vim.pack.add({'https://github.com/miikanissi/modus-themes.nvim'})

local colorscheme = 'modus_vivendi'
require('modus-themes').setup({
  style = colorscheme,
  line_nr_column_background = false,
  sign_column_background = false,

  on_colors = function(c)
    if colorscheme == 'modus_vivendi' then
      -- c.bg_dim = c.bg_alt
      c.bg_active = c.bg_alt
      c.bg_status_line_active = c.bg_alt
      c.bg_status_line_inactive = c.bg_alt
      c.border= "#444444"
      c.border_highlight = "#646464"
      c.visual = "#545490"
      vim.g.terminal_color_8 = c.fg_dim
    end
  end,

  on_highlights = function(hl, c)
    hl.CursorLineNr.bg = nil
    if colorscheme == 'modus_vivendi' then
      hl.CmpItemAbbrMatch.fg      = c.magenta_cooler
      hl.CmpItemAbbrMatchFuzzy.fg = c.magenta_cooler
      hl.FloatBorder.bg           = hl.NormalFloat.bg
      hl.FloatTitle.bg            = hl.NormalFloat.bg
      hl.PmenuSel                 = { bg = c.bg_hl_line }
      hl.PmenuThumb               = { bg = c.fg_dim }
      hl.SnacksPicker             = { link = 'NormalFloat' }
      hl.SnacksPickerCol          = { fg = c.fg_active, bg = nil }
      hl.SnacksPickerTree         = { fg = c.fg_active, bg = nil }
      hl.SnacksPickerIconFile     = { fg = c.fg_active, bg = nil }
      hl.SnacksPickerMatch        = { link = 'Visual' }
      hl.qfFileName.fg            = c.blue_faint
    end
  end,
})

vim.cmd.colorscheme(colorscheme)
