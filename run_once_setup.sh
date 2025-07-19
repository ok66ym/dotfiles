#!/bin/bash

# エラーが発生したらスクリプトを終了する
set -eu

echo "🚀 Starting setup..."

########################################
# Homebrew
########################################
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Apple Silicon Macの場合、brewのパスを通す処理が必要
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
fi

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
# chezmoi source-pathでスクリプトの絶対パスを取得できる
SCRIPTS_DIR="$(chezmoi source-path)/private_dot_scripts"

echo "Installing mise tools (languages, frameworks)..."
bash "${SCRIPTS_DIR}/_mise.sh"


echo "Setup complete!"
