# omarchy-dotfiles-config

Minhas configurações do [Omarchy](https://omarchy.org/) (Arch + Hyprland).

## O que tem aqui

| Pasta | Conteúdo |
|---|---|
| `config/hypr/` | Atalhos, input (ABNT2, Caps Lock normal), monitores, visual |
| `config/omarchy/` | Barra (`shell.json`), menu, hooks e tema próprio |
| `config/{alacritty,foot,kitty,ghostty}/` | Terminais |
| `config/btop/`, `config/mise/`, `config/starship.toml` | Ferramentas |
| `config/systemd/user/` | Postgres que liga sob demanda e desliga ocioso |
| `local/bin/` | Scripts do pgAdmin e do Postgres |
| `local/share/applications/` | Atalhos de apps e itens escondidos do menu |
| `local/share/icons/` | Ícone do pgAdmin |
| `plugins.txt` | Plugins de terceiros da barra (só a origem) |

## Atalhos

| Atalho | Abre |
|---|---|
| `Super + Shift + B` | Firefox |
| `Super + Shift + D` | Discord (no Firefox) |
| `Super + Shift + G` | GitHub (no Firefox) |
| `Super + Shift + M` | Spotify |
| `Super + Alt + Enter` | Tmux |

## Postgres e pgAdmin (Docker)

| | Liga quando… | Desliga quando… |
|---|---|---|
| Postgres (`postgres18`) | algo conecta em `localhost:5432` | ~15 min sem conexões |
| pgAdmin | abre pelo menu de apps | fecha a janela |

- Conexão: `localhost:5432`, usuário `postgres`, sem senha.
- O container escuta em `127.0.0.1:15432`; a porta 5432 é do `postgres-proxy.socket`, que liga o container e repassa as conexões.
- Dados nos volumes `postgres18-data` e `pgadmin-data`.

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

Postgres e pgAdmin (precisa do `chromium`):

```bash
mkdir -p ~/.local/bin ~/.local/share/icons ~/.config/systemd/user
cp local/bin/* ~/.local/bin/
cp local/share/icons/* ~/.local/share/icons/
cp config/systemd/user/* ~/.config/systemd/user/

docker run -d --name postgres18 --restart no -e POSTGRES_HOST_AUTH_METHOD=trust \
  -p 127.0.0.1:15432:5432 -v postgres18-data:/var/lib/postgresql postgres:18
docker run -d --name pgadmin --restart no --network host \
  -e PGADMIN_DEFAULT_EMAIL=admin@admin.com -e PGADMIN_DEFAULT_PASSWORD=admin \
  -e PGADMIN_LISTEN_ADDRESS=127.0.0.1 -e PGADMIN_LISTEN_PORT=5050 \
  -e PGADMIN_CONFIG_SERVER_MODE=False -e PGADMIN_CONFIG_MASTER_PASSWORD_REQUIRED=False \
  -v pgadmin-data:/var/lib/pgadmin dpage/pgadmin4

systemctl --user daemon-reload
systemctl --user enable --now postgres-proxy.socket postgres-idle-stop.timer
```
