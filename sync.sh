#!/bin/bash
set -e
cd "$(dirname "$0")"

R="rsync -a --delete --exclude=*.bak.* --exclude=*.sample"

mkdir -p config/omarchy local/share/applications

$R ~/.config/hypr/ config/hypr/
for f in shell.json shell.toml; do cp ~/.config/omarchy/$f config/omarchy/; done
for d in extensions hooks branding themes; do $R ~/.config/omarchy/$d/ config/omarchy/$d/; done

for d in alacritty foot kitty ghostty btop mise; do $R ~/.config/$d/ config/$d/; done
cp ~/.config/starship.toml config/

$R --exclude='claude-code-url-handler.desktop' --include='*.desktop' --exclude='*' \
  ~/.local/share/applications/ local/share/applications/

for d in ~/.config/omarchy/plugins/*/; do
  url=$(git -C "$d" remote get-url origin 2>/dev/null) && echo "$(basename "$d") $url"
done > plugins.txt

echo "Sincronizado. Revise com: git status"
