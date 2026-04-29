#!/usr/bin/env zsh
# CFO-Alpha: worktree 新規作成フック
#
# 作成されるウィンドウ構成:
#   Window 1 (terminal):
#     pane 1.1 — 汎用ターミナル（Claude Code 起動など）
#     pane 1.2 — npm run watch（フロントサーバー）
#   Window 2 (nvim):
#     Neovim をワークツリールートで起動
#
# .code-workspace を生成して VSCode もバックグラウンドで起動する。
#
# 将来バックエンドサーバーを起動する場合は pane 1.3 を作成して
# bundle exec rails server などを追加する
#
# 引数: $1=session_name  $2=wtdir

session_name="$1"
wtdir="$2"

[[ -d "$wtdir/front" ]] || exit 0

# .code-workspace を生成してVSCodeを開く
# worktree list の先頭エントリが常にメインリポジトリ
main_repo=$(git -C "$wtdir" worktree list --porcelain 2>/dev/null | awk 'NR==1{print $2; exit}')
if [[ -n "$main_repo" ]]; then
  wt_name=$(basename "$wtdir")
  ws_file="$(dirname "$wtdir")/${wt_name}.code-workspace"
  cat > "$ws_file" << EOF
{
  "folders": [
    { "path": "${wtdir}" }
  ],
  "settings": {
    "git.scanRepositories": ["${main_repo}"]
  }
}
EOF
  /usr/bin/open -a "Visual Studio Code" "$ws_file"
fi

# pane 1.2: フロントサーバー用（右ペイン）
tmux split-window -t "${session_name}:1.1" -h -c "$wtdir"
if [[ ! -d "$wtdir/node_modules" ]]; then
  tmux send-keys -t "${session_name}:1.2" \
    "npm i && echo '' && echo '✅ npm i done. Starting server...' && npm run watch" \
    Enter
else
  tmux send-keys -t "${session_name}:1.2" "npm run watch" Enter
fi

mkdir -p "$HOME/.config/tm-wt"
echo "$session_name" > "$HOME/.config/tm-wt/active-server"

# Window 2: Neovim をワークツリールートで起動
tmux new-window -t "${session_name}" -n "nvim" -c "$wtdir"
tmux send-keys -t "${session_name}:nvim" "nvim ." Enter

# 起動直後は Neovim window にフォーカスを移す
tmux select-window -t "${session_name}:nvim"
