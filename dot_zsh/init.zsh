########################################
# zinitの初期化と補完設定
########################################
if [[ -d "$HOME/.local/share/zinit/zinit.git" ]]; then

  # zinitの本体をロード
  source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

  # 補完設定
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit
fi
