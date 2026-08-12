# Temi coordinati per Ghostty, Starship, tmux e Neovim

Centrale dei temi del terminale: ogni tema colora **tutte** le app in modo
coerente e si cambia con un solo comando.

```sh
theme              # elenca i temi e mostra quello attivo
theme tokyo-night  # attiva Tokyo Night ovunque
theme catppuccin   # attiva Catppuccin ovunque
```

## Struttura

```
themes/<nome>/          un tema = una cartella con quattro file
  starship.toml           prompt Starship (incluse le impostazioni globali)
  ghostty.conf            colori Ghostty
  tmux.conf               status bar e bordi tmux
  nvim.lua                colorscheme Neovim ({ colorscheme, setup })
ghostty/base.conf       impostazioni Ghostty indipendenti dal tema (font, padding…)
bin/theme               lo script che cambia tema
active/                 stato locale (gitignorato), generato da bin/theme
extras/nvim/            file pronti da copiare nel repo nvim
```

`bin/theme <nome>` aggiorna i link in `active/` (per Starship, tmux e Neovim),
genera `active/ghostty.conf` concatenando `ghostty/base.conf` con i colori del
tema, poi ricarica al volo le app già aperte: tmux via `source-file`, le
istanze Neovim via `--remote-expr`, Ghostty via menu (o ⌘⇧, a mano). Starship
si aggiorna da solo al prompt successivo.

## Installazione

```sh
git clone git@github.com:frpiana/starship.git ~/.config/starship
~/.config/starship/bin/theme tokyo-night   # crea active/
mkdir -p ~/.config/ghostty
ln -sf ~/.config/starship/active/ghostty.conf ~/.config/ghostty/config
```

### Aggancio delle altre app (una tantum)

- **zsh** (`env.zsh` nel repo zsh):

  ```sh
  export STARSHIP_CONFIG=~/.config/starship/active/starship.toml
  ```

  e per comodità, in `aliases.zsh`:

  ```sh
  alias theme="$HOME/.config/starship/bin/theme"
  ```

- **tmux** (`tmux.conf` nel repo tmux): sostituire la riga che carica
  `themes/tokyo-night.tmux` con

  ```
  source-file -q ~/.config/starship/active/tmux.conf
  ```

- **Neovim** (repo nvim): copiare `extras/nvim/lua/core/theme.lua` in
  `lua/core/theme.lua`, sostituire `lua/plugins/colorscheme.lua` con
  `extras/nvim/lua/plugins/colorscheme.lua` e aggiungere in coda a `init.lua`:

  ```lua
  require("core.theme").apply()
  ```

  Per Catppuccin serve il plugin `catppuccin/nvim` (già dichiarato nel nuovo
  `colorscheme.lua`; lazy.nvim lo installa al primo avvio).

## Temi

- `tokyo-night` — il tema storico, armonizzato con i colori di Ghostty.
- `catppuccin` — la palette **Mocha ufficiale**, tenuta come riferimento.
- `tabby-matcha` — pantone personalizzato derivato da Catppuccin: base caffè
  tostato, testo crema, caramello tabby, verdi matcha e rosa sakura. Per
  Neovim è costruito sul plugin catppuccin via `color_overrides`.
- `tabby-matcha-latte` — versione diurna dello stesso pantone: fondo panna,
  testo caffè, accenti scuriti per il contrasto su chiaro.

Per creare un tema nuovo: copiare una cartella esistente in `themes/<nome>/` e
cambiare i colori nei quattro file.

## Note

- `command_timeout = 5000`: alzato perché `ghc` (Haskell) è lento all'avvio e
  sforava il timeout di default, generando warning.
- Il modulo C++ non esiste in Starship: il C++ è coperto dal modulo `[c]`, a cui
  sono state aggiunte le estensioni `cpp/cc/cxx/hpp/hh/hxx`.
- `themes/tokyo-night.toml` è un symlink di compatibilità verso
  `themes/tokyo-night/starship.toml`, così il vecchio valore di
  `STARSHIP_CONFIG` continua a funzionare finché non viene aggiornato.
