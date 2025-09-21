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

# Ctrl+e: ディレクトリ移動履歴検索
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
bindkey '^e' fzf-cdr

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
