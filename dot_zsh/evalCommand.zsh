# mise有効化
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# zコマンド
. `brew --prefix`/etc/profile.d/z.sh
