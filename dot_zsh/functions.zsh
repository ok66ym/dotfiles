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
    echo "以下のオプションを指定して操作を取り消す"
    echo "reset --hard：add, commit, 修正内容の取り消し"
    echo "reset --mixed：add, commitの取り消し"
    echo "reset --soft：commitのみの取り消し"
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
    echo -n "このブランチでpullしますか？(y/n) または、pushするブランチ名 | origin/ブランチ名を入力: "
    read -r response

    local target_ref
    local git_command
    
    # 2. ユーザーの入力に基づいて pull する参照先を決定
    case "$response" in
        # 'y' または 'Y' の場合 (現在のブランチ)
        [yY] )
            target_ref="$current_branch"
            git_command="git pull origin ${target_ref}"
            ;;
        # 'n' または 'N' の場合 (キャンセル)
        [nN] )
            echo "処理を中断しました。"
            return 0
            ;;
        # その他の文字列の場合 (ブランチ名または origin/ブランチ名)
        * )
            if [ -z "$response" ]; then
                echo "無効な入力です。処理を中断します。"
                return 1
            fi
            
            # 入力に "origin/" が含まれているかをチェック
            if [[ "$response" == origin/* ]]; then
                # origin/ブランチ名 の場合、コマンドは git pull origin/ブランチ名
                target_ref="$response"
                git_command="git pull ${target_ref}"
            else
                # 単なるブランチ名の場合、コマンドは git pull origin ブランチ名
                target_ref="$response"
                git_command="git pull origin ${target_ref}"
            fi
            ;;
    esac

    # 実行
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
    echo -n "このブランチでpushしますか？(y/n) または、pushするブランチ名 | origin/ブランチ名を入力: "
    read -r response

    local target_ref
    local git_command
    
    # 2. ユーザーの入力に基づいて push する参照先を決定
    case "$response" in
        # 'y' または 'Y' の場合 (現在のブランチ)
        [yY] )
            target_ref="$current_branch"
            git_command="git push origin ${target_ref}"
            ;;
        # 'n' または 'N' の場合 (キャンセル)
        [nN] )
            echo "処理を中断しました。"
            return 0
            ;;
        # その他の文字列の場合 (ブランチ名または origin/ブランチ名)
        * )
            if [ -z "$response" ]; then
                echo "無効な入力です。処理を中断します。"
                return 1
            fi
            
            # 入力に "origin/" が含まれているかをチェック
            if [[ "$response" == origin/* ]]; then
                # origin/ブランチ名 の場合、コマンドは git push origin/ブランチ名
                target_ref="$response"
                git_command="git push ${target_ref}"
            else
                # 単なるブランチ名の場合、コマンドは git push origin ブランチ名
                target_ref="$response"
                git_command="git push origin ${target_ref}"
            fi
            ;;
    esac

    # 実行
    eval "$git_command"
}

