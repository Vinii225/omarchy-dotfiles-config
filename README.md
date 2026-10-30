# omarchy-dotfiles-config

Minhas configurações do [Omarchy](https://omarchy.org/) (Arch + Hyprland).

## O que tem aqui

| Pasta | Conteúdo |
|---|---|
| `config/hypr/` | Atalhos, input (ABNT2, Caps Lock normal), monitores, visual |
| `config/omarchy/` | Barra (`shell.json`), menu, hooks e tema próprio |
| `config/{alacritty,foot,kitty,ghostty}/` | Terminais |
| `config/btop/`, `config/mise/`, `config/starship.toml` | Ferramentas |
| `local/share/applications/` | Atalhos de apps e itens escondidos do menu |
| `plugins.txt` | Plugins de terceiros da barra (só a origem) |

## Atalhos

| Atalho | Abre |
|---|---|
| `Super + Shift + B` | Firefox |
| `Super + Shift + D` | Discord (no Firefox) |
| `Super + Shift + G` | GitHub (no Firefox) |
| `Super + Shift + M` | Spotify |
| `Super + Alt + Enter` | Tmux |

## Atualizar o repo

```bash
./sync.sh
git add -A && git commit -m "Atualiza configs" && git push
```

## Restaurar num PC novo

```bash
cp -r config/. ~/.config/
cp -r local/share/applications/. ~/.local/share/applications/
while read -r id url; do git clone "$url" ~/.config/omarchy/plugins/"$id"; done < plugins.txt
hyprctl reload
```
