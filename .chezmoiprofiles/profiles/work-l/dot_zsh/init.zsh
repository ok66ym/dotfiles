# 共通初期化設定を読み込む
{{ include ".chezmoitemplates/zsh/common_init.zsh.part" . | indent 0 }}

# mise
eval "$(mise activate zsh)"
