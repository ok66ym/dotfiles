########################################
# 補完機能の設定
########################################
autoload -Uz compinit && compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
zstyle ':completion:*:default' menu select=1

# chpwdフックとcdrの設定 (ディレクトリ移動履歴)
# fzfの関数で使われているので、ここに含めます
autoload -Uz chpwd_recent_dirs cdr
chpwd_functions+=("chpwd_recent_dirs")
zstyle ':completion:*:*:cdr:*:*' menu-builder 'clist'
zstyle ':chpwd:*' recent-dirs-max 1000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':chpwd:*' recent-dirs-file "${XDG_CACHE_HOME:-$HOME/.cache}/chpwd-recent-dirs"
