# tm-wt 設定リファレンス

`~/.local/bin/tm-wt` スクリプトの設定ディレクトリ。

---

## ディレクトリ構造

```
~/.config/tm-wt/
├── README.md                          # このファイル
├── hooks/
│   └── <リポジトリ名>/
│       ├── on-create.zsh              # worktree 新規作成フック
│       └── on-attach.zsh              # worktree 接続フック
├── ports                              # セッション名:ポート対応表（手動設定）
├── repos                              # 登録済みリポジトリ一覧（自動生成）
└── active-server                      # 起動中サーバーのセッション名（自動生成）
```

chezmoi で管理するファイル: `hooks/**`, `ports`
chezmoi で管理しないファイル: `repos`, `active-server`（実行時生成）

---

## フックシステム

worktree の作成・接続時に、リポジトリ名に対応するフックスクリプトを自動実行する。

```
~/.config/tm-wt/hooks/<リポジトリの basename>/on-create.zsh
~/.config/tm-wt/hooks/<リポジトリの basename>/on-attach.zsh
```

`<リポジトリの basename>` は `git worktree list` の先頭パスの最終ディレクトリ名。
例: `/Users/foo/src/github.com/C-FO/CFO-Alpha` → `CFO-Alpha`

フックファイルが存在しない場合は何も実行されない（サーバー起動なし）。

### フックの種類と実行タイミング

| フック | 実行タイミング | 想定する用途 |
|--------|--------------|------------|
| `on-create.zsh` | `git worktree add` 後・tmux セッション作成直後（初回のみ） | `.code-workspace` 生成・VSCode オープン、pane 分割、`npm i`、サーバー初回起動 |
| `on-attach.zsh` | worktree セッションに入る時（新規/既存問わず） | pane の存在確認、サーバー再起動 |

### フックに渡される引数

```zsh
$1  session_name   # tmux セッション名（ブランチ名のスラッシュをハイフンに変換したもの）
$2  wtdir          # worktree のフルパス
```

### フックから使える情報・操作

```zsh
# pane 操作
tmux split-window -t "${session_name}:1.1" -h -c "$wtdir"   # 右ペイン作成
tmux send-keys -t "${session_name}:1.2" "command" Enter      # ペインにコマンド送信
tmux new-window -d -n "window-name" -c "$wtdir" -t "${session_name}"  # window 追加

# pane 状態確認
tmux list-panes -t "${session_name}:1" | wc -l               # ペイン数
tmux display-message -t "${session_name}:1.2" -p "#{pane_current_command}"  # 実行中コマンド

# active-server 管理（フロントサーバーが1つのみ許容される場合）
echo "$session_name" > "$HOME/.config/tm-wt/active-server"

# VSCode をマルチルートワークスペースで開く（worktree で拡張機能を正しく動作させるため）
main_repo=$(git -C "$wtdir" worktree list --porcelain 2>/dev/null | awk 'NR==1{print $2; exit}')
ws_file="$(dirname "$wtdir")/$(basename "$wtdir").code-workspace"
cat > "$ws_file" << EOF
{
  "folders": [
    { "path": "${main_repo}" },
    { "path": "${wtdir}" }
  ],
  "settings": {}
}
EOF
/usr/bin/open -a "Visual Studio Code" "$ws_file"
```

---

## 新しいリポジトリにフックを追加する方法

### 手順

1. フックディレクトリを作成する

```sh
mkdir -p ~/.config/tm-wt/hooks/<リポジトリ名>
```

2. `on-create.zsh` を作成する（worktree を初めて作成したときだけ実行）

```zsh
#!/usr/bin/env zsh
session_name="$1"
wtdir="$2"

# ここにサーバー起動・pane 作成のコードを書く
```

3. `on-attach.zsh` を作成する（worktree セッションに入るたびに実行）

```zsh
#!/usr/bin/env zsh
session_name="$1"
wtdir="$2"

# ここにサーバー再起動・pane 確認のコードを書く
```

4. chezmoi に追加する

```sh
chezmoi add ~/.config/tm-wt/hooks/<リポジトリ名>/on-create.zsh
chezmoi add ~/.config/tm-wt/hooks/<リポジトリ名>/on-attach.zsh
```

### テンプレート: フロントサーバー（npm）

`on-create.zsh`:
```zsh
#!/usr/bin/env zsh
session_name="$1"
wtdir="$2"

# pane 1.2: フロントサーバー用（右ペイン）
tmux split-window -t "${session_name}:1.1" -h -c "$wtdir"
if [[ ! -d "$wtdir/node_modules" ]]; then
  tmux send-keys -t "${session_name}:1.2" "npm i && npm run dev" Enter
else
  tmux send-keys -t "${session_name}:1.2" "npm run dev" Enter
fi
echo "$session_name" > "$HOME/.config/tm-wt/active-server"
```

`on-attach.zsh`:
```zsh
#!/usr/bin/env zsh
session_name="$1"
wtdir="$2"
ACTIVE_SERVER_FILE="$HOME/.config/tm-wt/active-server"

# pane 1.2 がなければ作成
pane_count=$(tmux list-panes -t "${session_name}:1" 2>/dev/null | wc -l | tr -d ' ')
if (( pane_count < 2 )); then
  tmux split-window -t "${session_name}:1.1" -h -c "$wtdir"
fi

# サーバー起動中なら何もしない
pane_cmd=$(tmux display-message -t "${session_name}:1.2" -p "#{pane_current_command}" 2>/dev/null)
[[ "$pane_cmd" == "node" || "$pane_cmd" == "npm" ]] && echo "$session_name" > "$ACTIVE_SERVER_FILE" && exit 0

# サーバー起動
if [[ ! -d "$wtdir/node_modules" ]]; then
  tmux send-keys -t "${session_name}:1.2" "npm i && npm run dev" Enter 2>/dev/null
else
  tmux send-keys -t "${session_name}:1.2" "npm run dev" Enter 2>/dev/null
fi
echo "$session_name" > "$ACTIVE_SERVER_FILE"
```

---

## 既存フックの修正方法

### CFO-Alpha フックの場所

```
~/.config/tm-wt/hooks/CFO-Alpha/on-create.zsh
~/.config/tm-wt/hooks/CFO-Alpha/on-attach.zsh
```

### CFO-Alpha にバックエンドサーバーを追加する場合

`on-create.zsh` に pane 1.3 の作成とサーバー起動コマンドを追記する。

```zsh
# on-create.zsh への追記例

# pane 1.3: バックエンドサーバー用（縦分割）
tmux split-window -t "${session_name}:1.2" -v -c "$wtdir"
tmux send-keys -t "${session_name}:1.3" "bundle exec rails server -p 3000" Enter
```

`on-attach.zsh` にも同様にバックエンドの状態確認と再起動を追記する。

修正後は chezmoi に反映する:

```sh
chezmoi add ~/.config/tm-wt/hooks/CFO-Alpha/on-create.zsh
chezmoi add ~/.config/tm-wt/hooks/CFO-Alpha/on-attach.zsh
chezmoi re-add  # または chezmoi diff で差分確認してから
```

---

## ports ファイル

worktree ごとにフロントサーバーのポートを変える場合に設定する。
デフォルトポートは `8888`（`tm-wt` スクリプト内の `DEFAULT_FRONT_PORT` で定義）。

```
# フォーマット: <セッション名>:<ポート番号>
torikawa-NDE-2028:8889
torikawa-NDE-2026:8891
```

セッション名はブランチ名のスラッシュをハイフンに変換したもの（例: `torikawa/NDE-2028` → `torikawa-NDE-2028`）。
