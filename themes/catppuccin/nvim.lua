-- Catppuccin Mocha — tema Neovim (catppuccin/nvim)
return {
  colorscheme = "catppuccin",
  setup = function()
    require("catppuccin").setup({
      flavour = "mocha",
      -- Qui si possono ricalibrare i colori col pantone personalizzato:
      -- color_overrides = { mocha = { base = "#1e1e2e", text = "#cdd6f4" } },
    })
  end,
}
