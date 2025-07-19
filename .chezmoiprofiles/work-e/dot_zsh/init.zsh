# 共通初期化設定を読み込む
{{ include ".chezmoitemplates/zsh/common_init.zsh.part" . | indent 0 }}

# mise
eval "$(/home/oka-yuma/.local/bin/mise activate zsh)"

# direnv
eval "$(direnv hook zsh)"

# asdf (bash→zshに変更)
# export ASDF_DATA_DIR=/opt/asdf-data
# . /opt/asdf/asdf.sh
# fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)

########################################
# fdev (認証情報などの読み込み)
########################################
# Configure zuora environment variables
eval $(fdev secrets load zuora_sandbox_api)
# fdev PAT
eval $(fdev pat load)
# Configure AWS_SES_ACCESS_KEY_ID and AWS_SES_SECRET_ACCESS_KEY
eval $(fdev secrets load aws_ses_credentials)
