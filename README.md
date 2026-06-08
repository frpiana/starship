# Configurazione di Starship per Ghostty su macOS

Prompt Starship con tema **Tokyo Night**, armonizzato con i colori di Ghostty.

## Struttura

- `themes/tokyo-night.toml` — **il file effettivamente letto da Starship**

La variabile `STARSHIP_CONFIG` (impostata in `~/.config/zsh/env.zsh`) punta
direttamente a questo tema. Starship legge un **solo** file e non ne fonde più
di uno: per questo le impostazioni globali (`add_newline`, `scan_timeout`,
`command_timeout`, `follow_symlinks`, modulo `[shell]`) vivono in testa al tema,
non in un file separato. Il vecchio `starship.toml` è stato rimosso perché,
con `STARSHIP_CONFIG` sul tema, non veniva mai letto.

## Note

- `command_timeout = 5000`: alzato perché `ghc` (Haskell) è lento all'avvio e
  sforava il timeout di default, generando warning.
- Il modulo C++ non esiste in Starship: il C++ è coperto dal modulo `[c]`, a cui
  sono state aggiunte le estensioni `cpp/cc/cxx/hpp/hh/hxx`.

## Installazione

```sh
git clone git@github.com:frpiana/starship.git ~/.config/starship
```
