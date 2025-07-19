# 共通エイリアスを読み込む
{{ include ".chezmoitemplates/zsh/common_aliases.zsh.part" . | indent 0 }}

# fdevの設定反映
alias fdevi='fdev-mcp-server info'

# saml2awsログイン
alias saml-login='saml2aws login --skip-prompt --force'

# 環境特有のgitコマンド設定
alias gplr='git pull --rebase origin develop'

# EC2操作系
alias dev-ec2-stop="aws ec2 stop-instances --hibernate --instance-ids $DEV_EC2_INSTANCE_ID && aws ec2 wait instance-stopped --instance-ids $DEV_EC2_INSTANCE_ID"
alias dev-ec2-stop-pause="aws ec2 stop-instances --instance-ids $DEV_EC2_INSTANCE_ID --hibernate && aws ec2 wait instance-stopped --instance-ids $DEV_EC2_INSTANCE_ID"
