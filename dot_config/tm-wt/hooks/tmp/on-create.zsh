#!/usr/bin/env zsh
# CFO-Alpha: worktree 新規作成フック
#
# 作成されるウィンドウ構成（tm-wt が共通ベースを作成、このフックは server window を担当）:
#   Window "server":
#     pane 1.1 — 汎用ターミナル（Claude Code 起動など）
#     pane 1.2 — npm run watch（フロントサーバー）
#   Window "nvim": ← tm-wt が作成
#   Window "cl":   ← tm-wt が作成
#
# .code-workspace を生成する（tm-code / prefix+e で VSCode を開く際に利用）。
#
# バックエンドサーバーを起動する場合は pane 1.3 を作成して
# bundle exec rails server などを追加する
#
# 引数: $1=session_name  $2=wtdir

session_name="$1"
wtdir="$2"

[[ -d "$wtdir/front" ]] || exit 0

# .code-workspace を生成する（worktree list の先頭エントリが常にメインリポジトリ）
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

# nvim / cl ウィンドウは tm-wt 本体が作成する
