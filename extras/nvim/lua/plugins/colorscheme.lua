-- Da copiare in ~/.config/nvim/lua/plugins/colorscheme.lua (sostituisce l'attuale).
-- I colorscheme vengono solo dichiarati: la scelta e la configurazione vivono
-- nel repo dei temi (~/.config/starship/themes/<tema>/nvim.lua) e vengono
-- applicate da core/theme.lua. lazy=true: il plugin giusto viene caricato
-- automaticamente alla prima require() da parte del setup del tema.
return {
  { "folke/tokyonight.nvim", lazy = true, priority = 1000 },
  { "catppuccin/nvim", name = "catppuccin", lazy = true, priority = 1000 },
}
