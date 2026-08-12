-- Tabby Matcha — tema Neovim
-- Costruito sul plugin catppuccin (flavour mocha) rimappando i colori sul
-- pantone: base caffè, superfici tostate, caramello, matcha, sakura.
return {
  colorscheme = "catppuccin",
  setup = function()
    require("catppuccin").setup({
      flavour = "mocha",
      color_overrides = {
        mocha = {
          base = "#221a15", -- moka
          mantle = "#1b1512",
          crust = "#15100d", -- espresso
          surface0 = "#33281f",
          surface1 = "#453629",
          surface2 = "#57443f",
          overlay0 = "#7a6754",
          overlay1 = "#8a7663", -- macchiato
          overlay2 = "#a08d78",
          subtext0 = "#c9b8a5", -- cappuccino
          subtext1 = "#d6c6b2",
          text = "#f2e5d5", -- crema
          rosewater = "#f7efe3", -- panna
          flamingo = "#d9a08c",
          pink = "#f0b3d2",
          mauve = "#e8a3b8", -- sakura (keyword)
          red = "#d97583",
          maroon = "#e58898",
          peach = "#e8a15d", -- caramello
          yellow = "#e8c98a",
          green = "#9dbf7a", -- matcha
          teal = "#8fc6b0",
          sky = "#a1d8c2",
          sapphire = "#aac4d4",
          blue = "#9db4c0", -- ardesia, smorzato
          lavender = "#e8a15d", -- caramello anche per CursorLineNr
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
