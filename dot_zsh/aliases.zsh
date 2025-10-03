########################################
# エイリアス
########################################
alias vi='nvim'
alias vim='nvim'

alias la='ls -a'
alias ls='ls -G'

# gitコマンド
alias gst='git status'
alias gsh='git stash'
alias gshu='git stash -u'
alias gsw='git switch'
alias gswc='git switch -c'
alias gco='git commit'
alias gch='git checkout'
alias gchb='git checkout -b'
alias gps='git push origin'
alias gpsb='git push origin $(git branch --show-current)'
alias gpl='git pull origin'
alias gplb='git pull origin $(git branch --show-current)'
alias gb='git branch'
alias gc='git clone'
alias gf='git fetch'
alias gm='git merge'
alias gl="git log"

# GitHub CLI
alias prv="gh pr view"
alias prw="gh pr create --w"

# pnpm
alias pn='pnpm'

# chezmoi
alias ch='chezmoi'
