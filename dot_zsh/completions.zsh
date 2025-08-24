########################################
# 補完機能の設定
########################################
autoload -Uz compinit && compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*:default' menu select=1

# chpwdフックとcdrの設定 (ディレクトリ移動履歴)
autoload -Uz chpwd_recent_dirs cdr
chpwd_functions+=("chpwd_recent_dirs")
zstyle ':completion:*:*:cdr:*:*' menu-builder 'clist'
zstyle ':chpwd:*' recent-dirs-max 100000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':chpwd:*' recent-dirs-file "${XDG_CACHE_HOME:-$HOME/.cache}/chpwd-recent-dirs"
