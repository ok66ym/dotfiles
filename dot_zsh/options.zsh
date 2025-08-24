########################################
# ヒストリ設定
########################################
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

########################################
# zshオプション
########################################
setopt print_eight_bit          # 日本語ファイル名を表示可能にする
setopt correct                  # 入力ミスを訂正する
# setopt hist_ignore_all_dups     # 同じコマンドをヒストリに残さない
setopt no_beep                  # beepを無効にする
setopt interactive_comments     # '#' 以降をコメントとして扱う
setopt auto_cd                  # ディレクトリ名だけでcdする
setopt hist_reduce_blanks       # ヒストリに保存するときに余分なスペースを削除する
setopt auto_param_slash         # ディレクトリ名の補完で末尾の / を自動的に付加

# 履歴を他のターミナルと即時共有するための設定
setopt SHARE_HISTORY            # 履歴を共有する
setopt INC_APPEND_HISTORY       # コマンド実行の都度、履歴をファイルに書き込む
setopt HIST_IGNORE_DUPS         # 直前のコマンドと重複するコマンドを記録しない
