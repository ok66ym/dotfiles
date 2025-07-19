#!/bin/bash

set -eu

if ! command -v mise &> /dev/null; then
    echo "mise is not installed. Please install it first."
    exit 1
fi

echo "Installing mise tools (languages, frameworks)..."
# 設定ファイル(/.config/mise/config.toml)に記述されているバージョンをインストール
mise install
