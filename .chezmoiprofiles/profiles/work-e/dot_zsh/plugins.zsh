# 共通プラグインを読み込む
{{ include ".chezmoitemplates/zsh/common_plugins.zsh.part" . | indent 0 }}


########################################
# 補完システム (compinit) の初期化
# TODO: ここは必要なのかわかっていない
########################################
autoload -Uz compinit && compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
zstyle ':completion:*:default' menu select=1
