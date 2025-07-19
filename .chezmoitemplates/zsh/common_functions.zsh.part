########################################
# fzfを使ったカスタム関数
########################################

# Ctrl+r: コマンド履歴検索
function fzf-select-history() {
  BUFFER=$(fc -l -n -r -1000 | fzf --query="$LBUFFER" --height 50% --layout=reverse --reverse)
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
