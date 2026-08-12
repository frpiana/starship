-- Tabby Matcha Latte — tema Neovim (versione diurna)
-- Costruito sul plugin catppuccin (flavour latte) rimappando i colori sul
-- pantone: fondo panna, testo caffè, accenti scuriti per il contrasto.
return {
  colorscheme = "catppuccin",
  setup = function()
    require("catppuccin").setup({
      flavour = "latte",
      color_overrides = {
        latte = {
          base = "#f3ead9", -- panna
          mantle = "#ece1cf",
          crust = "#e5d8c3",
          surface0 = "#e5d8c3",
          surface1 = "#d7c7ae",
          surface2 = "#c9b8a5", -- cappuccino
          overlay0 = "#b3a390",
          overlay1 = "#a3927e",
          overlay2 = "#8a7663",
          subtext0 = "#6b5847",
          subtext1 = "#5a4a3b",
          text = "#3a2c21", -- caffè
          rosewater = "#a86050", -- terracotta
          flamingo = "#a86050",
          pink = "#c25f88",
          mauve = "#b5537d", -- sakura scuro (keyword)
          red = "#b04a5e",
          maroon = "#98374b",
          peach = "#b06e2e", -- caramello scuro
          yellow = "#9a7828",
          green = "#61833a", -- matcha scuro
          teal = "#3f7d68",
          sky = "#2f6b56",
          sapphire = "#3d5a6d",
          blue = "#4f6d80", -- ardesia
          lavender = "#b06e2e", -- caramello anche per CursorLineNr
        },
      },
      custom_highlights = function(colors)
        return {
          -- Come nella simulazione: funzioni caramello, tipi matcha-teal
          Function = { fg = colors.peach },
          ["@function"] = { fg = colors.peach },
          ["@function.method"] = { fg = colors.peach },
          Type = { fg = colors.teal },
          ["@type"] = { fg = colors.teal },
          ["@variable.parameter"] = { fg = colors.flamingo, style = { "italic" } },
        }
      end,
    })
  end,
}
