#!/bin/bash

# ツールセットアップスクリプト
# Windows WSL (Ubuntu) 環境対応

echo "=== 情シス転職ポートフォリオ用ツールセットアップ開始 ==="

# システムアップデート
echo "システムアップデート中..."
sudo apt update && sudo apt upgrade -y

# 基本ツールのインストール
echo "基本ツールをインストール中..."
sudo apt install -y curl wget unzip git vim tree jq

# 1. Terraform のインストール
echo "Terraform をインストール中..."
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform

# 2. Google Cloud CLI のインストール
echo "Google Cloud CLI をインストール中..."
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-455.0.0-linux-x86_64.tar.gz
tar -xf google-cloud-cli-455.0.0-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh --quiet
source ~/.bashrc

# PATHに追加
echo 'export PATH="$HOME/google-cloud-sdk/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 3. Node.js と npm のインストール（フロントエンド開発用）
echo "Node.js をインストール中..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# 4. Docker のインストール
echo "Docker をインストール中..."
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

# 5. Python とツールのインストール
echo "Python 開発環境をセットアップ中..."
sudo apt install -y python3 python3-pip python3-venv
pip3 install --user boto3 google-cloud-storage

# 6. GitHub CLI のインストール
echo "GitHub CLI をインストール中..."
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install -y gh

# 7. VS Code リモート開発用設定
echo "VS Code 連携用設定..."
# WSL用のVS Code設定
mkdir -p ~/.vscode-server

# 8. Terraform 補完設定
echo "Terraform 補完を設定中..."
terraform -install-autocomplete

echo "=== インストール完了確認 ==="
echo "Terraform version:"
terraform --version
echo ""
echo "Google Cloud CLI version:"
gcloud --version
echo ""
echo "Node.js version:"
node --version
echo ""
echo "Docker version:"
docker --version
echo ""
echo "Git version:"
git --version
echo ""
echo "GitHub CLI version:"
gh --version

echo ""
echo "=== セットアップ完了 ==="
echo "次の手順："
echo "1. ターミナルを再起動するか、'source ~/.bashrc' を実行"
echo "2. 'gcloud auth login' でGoogle Cloudにログイン"
echo "3. 'gh auth login' でGitHubにログイン"
echo "4. プロジェクト作成を開始"
