-- Tokyo Night — tema Neovim (tokyonight.nvim personalizzato)
return {
  colorscheme = "tokyonight",
  setup = function()
    -- Avvicinato a Ghostty (#1a2130) ma mantenuto più scuro per creare contrasto
    local bg = "#1d2739"
    local bg_dark = "#141b28"
    local bg_highlight = "#2f3d55"
    local bg_search = "#1c5493"
    local bg_visual = "#2d5880"
    -- Avvicinato al testo di Ghostty (#c0cdd9)
    local fg = "#c8d4e2"
    local fg_dark = "#b4c2d1"
    local fg_gutter = "#687d95"
    local border = "#4c6a85"

    require("tokyonight").setup({
      style = "night",
      on_colors = function(colors)
        colors.bg = bg
        colors.bg_dark = bg_dark
        colors.bg_float = bg_dark
        colors.bg_highlight = bg_highlight
        colors.bg_popup = bg_dark
        colors.bg_search = bg_search
        colors.bg_sidebar = bg_dark
        colors.bg_statusline = bg_dark
        colors.bg_visual = bg_visual
        colors.border = border
        colors.fg = fg
        colors.fg_dark = fg_dark
        colors.fg_float = fg
        colors.fg_gutter = fg_gutter
        colors.fg_sidebar = fg_dark
      end,
    })
  end,
}
