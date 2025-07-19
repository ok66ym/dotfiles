#!/bin/bash

# エラーが発生したらスクリプトを終了する
set -eu

echo "Starting setup..."

echo "Running brew bundle..."
echo "Note: Kindle is installed from the App Store, not via Homebrew."
# .Brewfileはホームディレクトリに展開される
brew bundle --global

########################################
# zinit
########################################
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    echo "Installing zinit by cloning repository..."
    # .zshrcを自動編集させないよう、リポジトリをcloneするだけにする
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
else
    echo "zinit is already installed."
fi

########################################
# 言語やフレームワークのインストール
########################################
SCRIPTS_DIR="${HOME}/.local/share/chezmoi/private_dot_scripts"

echo "Installing mise tools (languages, frameworks)..."
bash "${SCRIPTS_DIR}/_mise.sh"

echo "Setup complete!"
