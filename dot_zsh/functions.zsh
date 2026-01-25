########################################
# fzfを使ったカスタム関数
########################################

# Ctrl+r: コマンド履歴検索
function fzf-select-history() {
  BUFFER=$(fc -l -n -r -100000 | fzf --query="$LBUFFER" --height 50% --layout=reverse --reverse)
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N fzf-select-history
bindkey '^r' fzf-select-history

# Ctrl+w: ディレクトリ移動履歴検索
function fzf-cdr() {
  local selected_dir
  selected_dir=$(cdr -l | sed 's/^[0-9*]* *//' | fzf --reverse --height 50%)

  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle redisplay
    CURSOR=$#BUFFER
  fi
}
zle -N fzf-cdr
bindkey '^w' fzf-cdr

# Ctrl+f: git add をインタラクティブに実行
function fzf-add() {
  local out q n addfiles
  while out=$(
    git status --short |
    awk '{if (substr($0,2,1) !~ / /) print $2}' |
    fzf-tmux --multi --exit-0 --expect=ctrl-d \
      --preview 'git diff --color=always -- {}' \
      --preview-window 'right:60%,border-sharp'
  ); do
    q=$(head -1 <<< "$out")
    n=$[$(wc -l <<< "$out") - 1]
    addfiles=($(echo $(tail "-$n" <<< "$out")))
    [[ -z "$addfiles" ]] && continue
    if [ "$q" = ctrl-d ]; then
      git diff --color=always -- "${addfiles[@]}" | less -R
    else
      git add -- "${addfiles[@]}"
    fi
  done
}
zle -N fzf-add
bindkey '^f' fzf-add

# Ctrl+b: gitブランチ選択
function fzf-branch() {
  local branches branch
  branches=$(git branch --color=always --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:green)(%(committerdate:relative))%(color:reset) %(contents:subject) [%(authorname)]' | sed 's/^\* //')
  branch=$(echo "$branches" | fzf --ansi --height='40%')
  if [[ -z "$branch" ]]; then
    return
  fi
  git checkout -q $(echo "$branch" | awk '{print $1}')
}
zle -N fzf-branch
bindkey '^b' fzf-branch

# Ctrl+g: Gitプロジェクトの切り替え
function fzf-ghq() {
    moveto=$(ghq root)/$(ghq list | fzf)

    if [[ "${moveto}" != "$(ghq root)/" ]]
    then
       cd $moveto
    fi
}
zle -N fzf-ghq
bindkey '^g' fzf-ghq

# tmux: セッション切り替え/作成
function ss(){
  ID="`tmux list-sessions`"
  create_new_session="Create New Session"
  if [[ -n "$ID" ]]; then
    ID="$ID\n${create_new_session}: $1"
  else
    ID="${create_new_session}: $1"
  fi
  ID="`echo $ID | fzf | cut -d: -f1`"
  if [[ "$ID" = "${create_new_session}" ]]; then
    if [[ -n "$TMUX" ]]; then
      if [[ -n "$1" ]]; then
        tmux new-session -d -s "$1"
        tmux switch-client -t "$1"
      else
        tmux new-session -d
        new_session=$(tmux list-sessions -F "#{session_name}" | tail -1)
        tmux switch-client -t "$new_session"
      fi
    else
      if [[ -n "$1" ]]; then
        tmux new-session -s "$1"
      else
        tmux new-session
      fi
    fi
  elif [[ -n "$ID" ]]; then
    if [[ -n "$TMUX" ]]; then
      tmux switch-client -t "$ID"
    else
      tmux attach-session -t "$ID"
    fi
  fi
}

# git reset実行時にオプション確認用の関数
function git-reset(){
  if [ "$#" -eq 0 ]; then
    echo "使用法: git-reset [オプション] [戻り先]"
    echo "--------------------------------------------------"
    echo "1. オプション（何を取り消すか）"
    echo "  --hard  : add, commit, 修正内容すべて"
    echo "  --mixed : add, commit を取り消す"
    echo "  --soft  : commit のみを取り消す"
    echo ""
    echo "2. 戻り先（どこまで戻るか）"
    echo "  (省略した場合) : HEAD（現在のコミット）が指定されます"
    echo "  [ハッシュ値] : git log (--oneline) で確認した英数字（例: a1b2c3d）"
    echo "  HEAD^        : 1つ前のコミットに戻る"
    echo "  HEAD~n       : n個前のコミットに戻る（例: HEAD~3）"
    echo "  HEAD@{n}     : n個前のコミットに戻る（例: HEAD@{3}）"
    echo "  ORIG_HEAD    : reset実行直前の状態に戻す（間違えた時用）"
    echo "--------------------------------------------------"
    return 0
  fi
# 関数内で元のコマンド名（git reset）を呼び出す
  git reset "$@"
}

function git-pull() {
    # 1. 現在のブランチ名を取得
    local current_branch
    # 2>/dev/null はエラーメッセージ（Gitリポジトリでない場合など）を非表示にする
    current_branch=$(git branch --show-current 2>/dev/null)

    if [ -z "$current_branch" ]; then
        echo "エラー: 現在のディレクトリはGitリポジトリではありません。"
        return 1
    fi

    echo ""
    echo "現在のブランチ: >> ${current_branch} "
    echo ""
    echo -n "このブランチでpullしますか？(y/n) または、pullするブランチ名を指定する: "
    read -r response

    local target_ref
    local git_command

    # 2. ユーザーの入力に基づいて pull する参照先を決定
    case "$response" in
        # 'y' または 'Y' の場合 (現在のブランチ)
        [yY]|"")
            target_ref="$current_branch"
            git_command="git pull origin ${target_ref}"
            ;;
        # 'n' または 'N' の場合 (キャンセル)
        [nN] )
            echo "処理を中断しました。"
            return 0
            ;;
        # その他の文字列の場合 (ブランチ名指定とみなす)
        * )
            if [ -z "$response" ]; then
                echo "無効な入力です。処理を中断します。"
                return 1
            fi

            # 【変更点】origin/判定を削除し、単純にブランチ名として扱います
            # 入力例: "main" -> "git pull origin main"
            target_ref="$response"
            git_command="git pull origin ${target_ref}"
            ;;
    esac

    # 実行
    echo "実行コマンド: $git_command"
    eval "$git_command"
}

function git-push() {
    # 1. 現在のブランチ名を取得
    local current_branch
    # 2>/dev/null はエラーメッセージ（Gitリポジトリでない場合など）を非表示にする
    current_branch=$(git branch --show-current 2>/dev/null)

    if [ -z "$current_branch" ]; then
        echo "エラー: 現在のディレクトリはGitリポジトリではありません。"
        return 1
    fi

    echo ""
    echo "現在のブランチ: >> ${current_branch} "
    echo ""
    echo -n "このブランチでpushしますか？(y/n) または、pushするブランチ名を入力: "
    read -r response

    local target_ref
    local git_command

    # 2. ユーザーの入力に基づいて push する参照先を決定
    case "$response" in
        # 'y' または 'Y' の場合 (現在のブランチ)
        [yY]|"")
            target_ref="$current_branch"
            git_command="git push origin ${target_ref}"
            ;;
        # 'n' または 'N' の場合 (キャンセル)
        [nN] )
            echo "処理を中断しました。"
            return 0
            ;;
        # その他の文字列の場合 (ブランチ名指定とみなす)
        * )
            if [ -z "$response" ]; then
                echo "無効な入力です。処理を中断します。"
                return 1
            fi

            # 【変更点】origin/判定を削除し、単純にブランチ名として扱います
            # 入力例: "main" -> "git push origin main"
            target_ref="$response"
            git_command="git push origin ${target_ref}"
            ;;
    esac

    # 実行
    echo "実行コマンド: $git_command"
    eval "$git_command"
}

# 新規リポジトリを作成する関数(リモート→ローカル)
function start-git-project() {
  # --- ヘルプ ---
  function _gnew_show_help() {
    echo "使用法: gnew <リポジトリ名> [オプション]"
    echo ""
    echo "デフォルト:"
    echo "  - 公開範囲:      Private (非公開)"
    echo "  - 初期ファイル:  なし (空のリポジトリ)"
    echo "  - ghqでクローン: SSH方式"
    echo ""
    echo "オプション: オプションを指定するとfirst commitが作成される"
    echo "  --add-readme           README.md を作成する"
    echo "  --public               Public (公開) リポジトリとして作成"
    echo "  --description \"文\"   リポジトリの説明文を設定"
    echo "  --gitignore <言語>     .gitignoreを追加 (例: Python, Node, Go)"
    echo "  --license <key>        ライセンスを追加 (例: mit, apache-2.0)"
  }

  # --- ヘルプ表示の判定 ---
  if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$2" = "-h" ] || [ "$2" = "--help" ]; then
    _gnew_show_help
    return 0
  fi

  # --- 変数設定 ---
  local repo_name=$1
  shift # 第一引数を取り除く

  local user="ok66ym"

  # リポジトリ名のスラッシュ対策
  if [[ "$repo_name" == *"/"* ]]; then
    repo_name="${repo_name##*/}"
  fi
  local target_repo="${user}/${repo_name}"

  echo "🔨 Creating private repository: ${target_repo}..."

  # --- GitHubリポジトリ作成 ---
  gh repo create "$target_repo" \
    --private \
    --clone=false \
    "$@"

  if [ $? -ne 0 ]; then
    echo "Failed to create repository."
    return 1
  fi

  # --- ghq で SSH クローン ---
  echo "📥 Cloning via SSH with ghq..."
  ghq get "git@github.com:${target_repo}.git"

  # --- ディレクトリへ移動 ---
  local repo_path
  repo_path=$(ghq list -p -e "github.com/${target_repo}")

  if [ -d "$repo_path" ]; then
    cd "$repo_path"

    # 状況確認: READMEがない(空の)場合は案内を出す
    if [ ! -f "README.md" ]; then
       echo "Note: You created an empty repository."
       echo "   Run 'echo \"# ${repo_name}\" >> README.md' and commit to start."
    fi
  else
    echo "Error: Directory not found at $repo_path"
    return 1
  fi
}
