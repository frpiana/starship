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

## Installazione (macOS)

I repo [zsh](https://github.com/frpiana/zsh), [tmux](https://github.com/frpiana/tmux)
e [nvim](https://github.com/frpiana/nvim) sono già agganciati a questo sistema
(`STARSHIP_CONFIG` e alias `theme` in zsh, `source-file` del tema attivo in tmux,
`core/theme.lua` in nvim — la copia di riferimento è in `extras/nvim/`): basta
clonarli in `~/.config/` e agganciare Ghostty.

```sh
git clone git@github.com:frpiana/starship.git ~/.config/starship
~/.config/starship/bin/theme tokyo-night   # crea active/
mkdir -p ~/.config/ghostty
ln -sf ~/.config/starship/active/ghostty.conf ~/.config/ghostty/config
```

Attenzione a un eventuale config preesistente in
`~/Library/Application Support/com.mitchellh.ghostty/config`: su macOS Ghostty
lo legge **in aggiunta** a quello XDG e vince sulle chiavi in conflitto —
va rimosso o rinominato (es. `config.bak`).

La ricarica automatica di Ghostty al cambio tema richiede il permesso di
Accessibilità per il terminale (Impostazioni di Sistema → Privacy e Sicurezza);
in alternativa, ⌘⇧, dentro Ghostty.

## Installazione su Linux (Debian)

Il sistema è portabile: stessi percorsi XDG, script POSIX. Passaggi:

```sh
# 1. Dipendenze (starship dal suo installer ufficiale se non pacchettizzato)
sudo apt install tmux zsh eza fonts-jetbrains-mono
curl -sS https://starship.rs/install.sh | sh

# 2. I quattro repo in ~/.config/
git clone git@github.com:frpiana/starship.git ~/.config/starship
git clone git@github.com:frpiana/zsh.git      ~/.config/zsh
git clone git@github.com:frpiana/tmux.git     ~/.config/tmux
git clone git@github.com:frpiana/nvim.git     ~/.config/nvim

# 3. Bootstrap di zsh (ZDOTDIR sta fuori dai repo)
echo 'export ZDOTDIR="$HOME/.config/zsh"' > ~/.zshenv

# 4. Tema attivo + aggancio Ghostty (su Linux legge solo il percorso XDG)
~/.config/starship/bin/theme tokyo-night
mkdir -p ~/.config/ghostty
ln -sf ~/.config/starship/active/ghostty.conf ~/.config/ghostty/config
```

Differenze rispetto a macOS:

- **Neovim ≥ 0.10 obbligatorio** (la config usa `vim.uv` e lazy.nvim): il
  pacchetto di Debian *stable* è troppo vecchio — usare trixie/backports,
  l'AppImage ufficiale o `bob`.
- **Font**: servono anche i glifi Nerd Font (JetBrainsMono Nerd Font e
  Symbols Nerd Font Mono da [nerdfonts.com](https://www.nerdfonts.com), il
  pacchetto `fonts-jetbrains-mono` da solo non basta per le icone).
- **Ricarica di Ghostty**: il blocco AppleScript viene saltato (guard su
  Darwin); la scorciatoia è **Ctrl+Shift+,**.
- Le chiavi `macos-*` nella base Ghostty vengono ignorate senza errori;
  `background-blur` dipende dal compositor (KDE sì, GNOME tipicamente no).

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
