########################################
# プラグイン管理
########################################
# zinit annex (拡張機能)
  zinit light-mode for \
      zdharma-continuum/zinit-annex-as-monitor \
      zdharma-continuum/zinit-annex-bin-gem-node \
      zdharma-continuum/zinit-annex-patch-dl \
      zdharma-continuum/zinit-annex-rust

# Powerlevel10k (プロンプトテーマ)
zinit ice depth=1; zinit light romkatv/powerlevel10k

# シンタックスハイライト
zinit light zsh-users/zsh-syntax-highlighting

# 履歴からの自動補完
zinit light zsh-users/zsh-autosuggestions

# 高機能なコマンド補完
zinit ice lucid wait'0'; zinit light zsh-users/zsh-completions
