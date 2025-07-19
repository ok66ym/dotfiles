#!/bin/bash

# エラーが発生したらスクリプトを終了する
set -eu

echo "🚀 Starting setup..."

# --- Homebrew ---
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # M1/M2 Macの場合、brewのパスを通す処理が必要
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
fi

echo "Running brew bundle..."
# .Brewfileはホームディレクトリに展開される
brew bundle --global

# --- zinit ---
if [ ! -d "${HOME}/.zinit" ]; then
    echo "⚡ Installing zinit..."
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
else
    echo "⚡ zinit is already installed."
fi

# --- Helper Scripts ---
# chezmoi source-pathでスクリプトの絶対パスを取得できる
SCRIPTS_DIR="$(chezmoi source-path)/private_dot_scripts"

echo "📦 Installing mise tools (languages, frameworks)..."
bash "${SCRIPTS_DIR}/_mise.sh"

echo "💻 Installing VS Code extensions..."
bash "${SCRIPTS_DIR}/_vscode.sh"

echo "✅ Setup complete!"
