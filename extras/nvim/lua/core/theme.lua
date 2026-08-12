-- Applica il tema attivo scelto con lo script `theme` (repo starship).
-- Da copiare in ~/.config/nvim/lua/core/theme.lua e richiamare in init.lua
-- con: require("core.theme").apply()
--
-- Il file active/nvim.lua restituisce:
--   { colorscheme = "<nome>", setup = function() ... end }

local M = {}

local active_file = vim.fn.expand("~/.config/starship/active/nvim.lua")
local name_file = vim.fn.expand("~/.config/starship/active/THEME")
local applied = nil

local function read_name()
  local f = io.open(name_file, "r")
  if not f then
    return nil
  end
  local name = f:read("*l")
  f:close()
  return name
end

function M.apply()
  local ok, theme = pcall(dofile, active_file)
  if not ok or type(theme) ~= "table" then
    -- Nessun tema attivo (es. `theme` mai eseguito): fallback ragionevole
    pcall(vim.cmd.colorscheme, "tokyonight")
    return
  end
  if theme.setup then
    pcall(theme.setup)
  end
  pcall(vim.cmd.colorscheme, theme.colorscheme)
  applied = read_name()
end

-- Richiamata dallo script `theme` sulle istanze aperte via --remote-expr
_G.ThemeApply = function()
  M.apply()
  return ""
end

-- Se il tema è cambiato mentre nvim non aveva il focus, riallineati al rientro
vim.api.nvim_create_autocmd("FocusGained", {
  group = vim.api.nvim_create_augroup("ActiveTheme", { clear = true }),
  callback = function()
    if read_name() ~= applied then
      M.apply()
    end
  end,
})

return M
