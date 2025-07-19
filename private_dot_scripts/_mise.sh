#!/bin/bash

set -eu

if ! command -v mise &> /dev/null; then
    echo "mise is not installed. Please install it first."
    exit 1
fi

echo "Installing tools defined in mise config..."
# 設定ファイルに記述されているプラグインをインストール
mise plugins install
# 設定ファイルに記述されているバージョンをインストール
mise install
