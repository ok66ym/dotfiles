# 共通カスタム関数(fzf)を読み込む
{{ include ".chezmoitemplates/zsh/common_functions.zsh.part" . | indent 0 }}

########################################
# その他カスタム関数
########################################
# EC2起動
start-dev-ec2() {
  # 各自のfreee-nssdb.yml のキー名に書き換える
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

# tmux: プロジェクト環境の立ち上げ
function dev(){
  tmux source-file "$HOME/.tmux.$1.config"
}

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
