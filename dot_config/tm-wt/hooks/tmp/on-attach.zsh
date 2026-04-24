#!/usr/bin/env zsh
# CFO-Alpha: worktree 接続フック（セッションに入る時 / 新規セッション作成時）
# pane 1.2 が存在しなければ作成し、サーバーが停止していれば起動する
#
# 引数: $1=session_name  $2=wtdir

session_name="$1"
wtdir="$2"
ACTIVE_SERVER_FILE="$HOME/.config/tm-wt/active-server"

[[ -d "$wtdir/front" ]] || exit 0

# pane 1.2 がなければ作成
pane_count=$(tmux list-panes -t "${session_name}:1" 2>/dev/null | wc -l | tr -d ' ')
if (( pane_count < 2 )); then
  tmux split-window -t "${session_name}:1.1" -h -c "$wtdir"
fi

# サーバー状態確認: 起動中なら active-server ファイルだけ同期
pane_cmd=$(tmux display-message -t "${session_name}:1.2" -p "#{pane_current_command}" 2>/dev/null)
if [[ "$pane_cmd" == "node" || "$pane_cmd" == "npm" ]]; then
  mkdir -p "$(dirname "$ACTIVE_SERVER_FILE")"
  echo "$session_name" > "$ACTIVE_SERVER_FILE"
  exit 0
fi

# サーバー未起動 → 起動
if [[ ! -d "$wtdir/node_modules" ]]; then
  tmux send-keys -t "${session_name}:1.2" "npm i && npm run watch" Enter 2>/dev/null
else
  tmux send-keys -t "${session_name}:1.2" "npm run watch" Enter 2>/dev/null
fi
mkdir -p "$(dirname "$ACTIVE_SERVER_FILE")"
echo "$session_name" > "$ACTIVE_SERVER_FILE"
