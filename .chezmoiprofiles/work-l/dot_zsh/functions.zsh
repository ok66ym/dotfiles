# 共通カスタム関数(fzf)を読み込む
{{ include ".chezmoitemplates/zsh/common_functions.zsh.part" . | indent 0 }}

########################################
# その他カスタム関数
########################################
# AWS SAMLログインとプロファイル設定
function s2a () {
  saml2aws login -a $1 --skip-prompt --force
  export AWS_PROFILE=$1
  aws sts get-caller-identity
}

# EC2インスタンス起動
start-dev-ec2() {
  # 各自のfreee-nssdb.yml のキー名に書き換えてください
  developer=oka-yuma
  # get instance-id
  instance_id=$(
    aws ec2 describe-instances --filters "Name=tag:Name,Values=${developer}-eng-dev" | jq '.Reservations[0].Instances[0].InstanceId' -r
  )
  # start instance
  aws ec2 start-instances --instance-ids $instance_id \
    && aws ec2 wait instance-running --instance-ids $instance_id \
    && aws ec2 wait instance-status-ok --instance-ids $instance_id \
    && echo -e "\e[32minstance runnnin and status ok"
}
