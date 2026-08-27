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
themes/<nome>/          un tema = una cartella con sei file
  starship.toml           prompt Starship (incluse le impostazioni globali)
  ghostty.conf            colori Ghostty (il terminale su macOS)
  kitty.conf              colori kitty (il terminale su Debian)
  tabby.yaml              schema colori Tabby (terminale alternativo)
  tmux.conf               status bar e bordi tmux
  nvim.lua                colorscheme Neovim ({ colorscheme, setup })
ghostty/base.conf       impostazioni Ghostty indipendenti dal tema (font, padding…)
tabby/base.yaml         impostazioni Tabby indipendenti dal tema
                        (la base di kitty vive nel repo kitty, come per tmux)
bin/theme               lo script che cambia tema
active/                 stato locale (gitignorato), generato da bin/theme
extras/nvim/            file pronti da copiare nel repo nvim
```

`bin/theme <nome>` aggiorna i link in `active/` (per Starship, tmux, Neovim e
kitty — il `kitty.conf` del [repo kitty](https://github.com/frpiana/kitty) fa
`include` del link), genera `active/ghostty.conf` concatenando
`ghostty/base.conf` con i colori del tema e `active/tabby.yaml` iniettando lo
schema del tema in `tabby/base.yaml` (copiato poi nelle cartelle di config di
Tabby esistenti — vedi il [repo tabby](https://github.com/frpiana/tabby)), poi
ricarica al volo le app già aperte: tmux via `source-file`, kitty via
`SIGUSR1`, le istanze Neovim via `--remote-expr`, Ghostty via menu (o ⌘⇧, a
mano). Starship si aggiorna da solo al prompt successivo. **Tabby è
l'eccezione: non rilegge il config dall'esterno, va riavviato dopo il cambio
tema.**

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
sudo apt install kitty tmux zsh eza fonts-jetbrains-mono
curl -sS https://starship.rs/install.sh | sh

# 2. I repo in ~/.config/ (kitty e tabby sono anche le config dir delle app)
git clone git@github.com:frpiana/starship.git ~/.config/starship
git clone git@github.com:frpiana/zsh.git      ~/.config/zsh
git clone git@github.com:frpiana/tmux.git     ~/.config/tmux
git clone git@github.com:frpiana/nvim.git     ~/.config/nvim
git clone git@github.com:frpiana/kitty.git    ~/.config/kitty
git clone git@github.com:frpiana/tabby.git    ~/.config/tabby   # opzionale

# 3. Bootstrap di zsh: ZDOTDIR sta fuori dai repo, e zsh va reso shell di login.
#    Su Debian la shell di default è bash: senza chsh il terminale apre bash,
#    .zshrc non viene mai letto e il prompt Starship non compare (prompt spoglio,
#    senza alcun errore a video). Su macOS zsh è già la shell di default,
#    ed è per questo che là il passo non serve.
cat > ~/.zshenv <<'EOF'
export ZDOTDIR="$HOME/.config/zsh"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
EOF
sudo sed -i 's/^# en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen && sudo locale-gen
chsh -s "$(command -v zsh)"   # richiede logout/login per avere effetto

# 4. Tema attivo + aggancio Ghostty (su Linux legge solo il percorso XDG)
~/.config/starship/bin/theme tokyo-night
mkdir -p ~/.config/ghostty
ln -sf ~/.config/starship/active/ghostty.conf ~/.config/ghostty/config
```

Differenze rispetto a macOS:

- **La shell di login va cambiata a mano**: su macOS zsh è già il default, su
  Debian no. E' la causa più comune di "Starship non funziona su Linux": il
  prompt resta quello di bash (`user@host:~$`) e non compare **nessun errore**,
  perchè non è Starship a fallire — è `~/.config/zsh/.zshrc` a non essere mai
  letto. Diagnosi in una riga:

  ```sh
  echo "shell=$0  ZDOTDIR=${ZDOTDIR:-VUOTO}"; command -v starship
  ```

  `shell=bash` -> manca il `chsh` del passo 3; `ZDOTDIR` vuoto -> manca
  `~/.zshenv`; `starship` senza percorso -> binario non installato. In
  alternativa al `chsh` (o per provare senza cambiare la shell di sistema) si
  può aggiungere `shell /usr/bin/zsh` a `~/.config/kitty/kitty.conf`, ma il
  `chsh` resta la strada giusta: vale anche per tmux, SSH e i terminali diversi
  da kitty.
- **Il terminale è kitty, non Ghostty**: con il repo
  [kitty](https://github.com/frpiana/kitty) clonato in `~/.config/kitty` non
  serve alcun aggancio — il suo `kitty.conf` (versionato) fa `include` di
  `../starship/active/kitty.conf` e `bin/theme` ricarica kitty al volo via
  `SIGUSR1`. Il passo 4 con Ghostty resta valido solo se Ghostty è installato
  anche su Linux.
- **Tabby** (terminale alternativo, repo
  [tabby](https://github.com/frpiana/tabby) in `~/.config/tabby`): `bin/theme`
  scrive direttamente `~/.config/tabby/config.yaml` (base + schema del tema);
  dopo il cambio tema Tabby va riavviato.
- **Neovim ≥ 0.11 obbligatorio** (la config usa `vim.lsp.config` e il branch
  `main` di nvim-treesitter): il pacchetto apt di trixie è fermo a 0.10 e il
  backport è stato rifiutato — installare il tarball ufficiale in `/opt` (o
  usare `bob`). Passi dettagliati e pacchetti apt necessari nel
  [README del repo nvim](https://github.com/frpiana/nvim).
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
cambiare i colori nei sei file.

## Note

- `command_timeout = 5000`: alzato perché `ghc` (Haskell) è lento all'avvio e
  sforava il timeout di default, generando warning.
- Il modulo C++ non esiste in Starship: il C++ è coperto dal modulo `[c]`, a cui
  sono state aggiunte le estensioni `cpp/cc/cxx/hpp/hh/hxx`.
- `themes/tokyo-night.toml` è un symlink di compatibilità verso
  `themes/tokyo-night/starship.toml`, così il vecchio valore di
  `STARSHIP_CONFIG` continua a funzionare finché non viene aggiornato.
