#!/bin/bash
set -eu

# 1. Homebrew のインストール (未インストールの場合)
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# 2. Brewfile に基づくインストール
echo "Installing packages from Brewfile..."
brew bundle --verbose --file=./Brewfile

# 3. Chezmoi の初期化と適用
# このリポジトリ自体をソースとして設定ファイルを適用
echo "Applying dotfiles with chezmoi..."
if ! command -v chezmoi &> /dev/null; then
    echo "Error: chezmoi is not installed. Please check Brewfile installation."
    exit 1
fi

chezmoi init --apply --source=.

# 4. mise によるランタイムのインストール
echo "Installing runtimes with mise..."
if command -v mise &> /dev/null; then
    # chezmoi apply の後に実行することで、配置された config.toml が反映される
    mise install
else
    echo "Warning: mise not found, skipping runtime installation."
fi

echo "Done."
