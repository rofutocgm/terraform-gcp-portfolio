# =============================================================================
# ENTERPRISE INFRASTRUCTURE MAKEFILE
# =============================================================================
# Terraform操作を安全・簡単・統一的に実行するためのMakefileです
# 
# 主要コマンド:
#   make help              # ヘルプ表示
#   make setup-auth        # 初回認証セットアップ (gcloud + terraform + gcp-project)
#   make auth-status       # 認証状態の確認
#   make login-gcloud      # Google Cloud認証
#   make login-terraform   # Terraform Cloud認証
#   make set-gcp-project   # GCPプロジェクト設定
#   make init              # Terraform初期化
#   make plan              # インフラ変更計画の確認
#   make apply             # インフラ変更の適用
#   make validate          # Terraformコード検証
#   make format            # コードフォーマット
#   make clean             # 一時ファイル・キャッシュ削除
#   make security-check    # セキュリティチェック
#   make commit-check      # コミット前チェック
#   make destroy           # 全リソース削除 (危険!)

# =============================================================================
# 設定変数
# =============================================================================

# Terraformのディレクトリパス
TERRAFORM_DIR := terraform/global

# 環境変数（dev, staging, prodなど）
ENV := dev

# =============================================================================
# デフォルトターゲット
# =============================================================================

.DEFAULT_GOAL := help

# =============================================================================
# 認証・ログイン操作
# =============================================================================

.PHONY: login-gcloud
login-gcloud: ## 🔑 Google Cloud認証
	@echo "🔑 Google Cloud認証"
	@echo "=================="
	@echo "ブラウザでGoogle認証画面が開きます..."
	@gcloud auth login
	@echo ""
	@echo "✅ Google Cloud認証完了"
	@echo "💡 プロジェクト設定: make set-gcp-project"
	@echo ""

.PHONY: login-gcloud-app
login-gcloud-app: ## 🔑 Google Cloud Application Default認証
	@echo "🔑 Google Cloud Application Default認証"
	@echo "=========================================="
	@echo "ローカル開発用のApplication Default Credentials設定"
	@gcloud auth application-default login
	@echo ""
	@echo "✅ Application Default認証完了"
	@echo ""

.PHONY: login-terraform
login-terraform: ## 🔑 Terraform Cloud認証
	@echo "🔑 Terraform Cloud認証"
	@echo "======================"
	@echo "ブラウザでTerraform Cloud認証画面が開きます..."
	@terraform login
	@echo ""
	@echo "✅ Terraform Cloud認証完了"
	@echo ""

.PHONY: login-github
login-github: ## 🔑 GitHub CLI認証
	@echo "🔑 GitHub CLI認証"
	@echo "=================="
	@if command -v gh >/dev/null 2>&1; then \
		echo "GitHub CLI認証を開始します..."; \
		gh auth login; \
		echo ""; \
		echo "✅ GitHub CLI認証完了"; \
	else \
		echo "❌ GitHub CLI (gh) がインストールされていません"; \
		echo "💡 インストール: https://cli.github.com/"; \
	fi
	@echo ""

.PHONY: set-gcp-project
set-gcp-project: ## 🎯 GCPプロジェクト設定
	@echo "🎯 GCPプロジェクト設定"
	@echo "===================="
	@echo "現在のプロジェクト: $$(gcloud config get-value project 2>/dev/null || echo 'なし')"
	@echo ""
	@read -p "プロジェクトIDを入力してください: " project_id && \
	gcloud config set project $$project_id
	@echo ""
	@echo "✅ プロジェクト設定完了"
	@echo "設定されたプロジェクト: $$(gcloud config get-value project)"
	@echo ""

.PHONY: auth-status
auth-status: ## 📊 全認証状態の確認
	@echo "📊 認証状態確認"
	@echo "==============="
	@echo ""
	@echo "🔍 Google Cloud:"
	@if gcloud auth list --filter=status:ACTIVE --format="value(account)" 2>/dev/null | head -1 | grep -q .; then \
		echo "  ✅ ログイン済み: $$(gcloud auth list --filter=status:ACTIVE --format='value(account)' | head -1)"; \
		echo "  📋 プロジェクト: $$(gcloud config get-value project 2>/dev/null || echo 'なし')"; \
	else \
		echo "  ❌ 未ログイン (make login-gcloud を実行)"; \
	fi
	@echo ""
	@echo "🔍 Terraform Cloud:"
	@if [ -f ~/.terraform.d/credentials.tfrc.json ] && [ -s ~/.terraform.d/credentials.tfrc.json ]; then \
		echo "  ✅ 認証済み"; \
	else \
		echo "  ❌ 未認証 (make login-terraform を実行)"; \
	fi
	@echo ""
	@echo "🔍 GitHub CLI:"
	@if command -v gh >/dev/null 2>&1; then \
		if gh auth status >/dev/null 2>&1; then \
			echo "  ✅ 認証済み: $$(gh api user --jq .login 2>/dev/null || echo 'ユーザー名取得失敗')"; \
		else \
			echo "  ❌ 未認証 (make login-github を実行)"; \
		fi; \
	else \
		echo "  ⚠️  GitHub CLI未インストール"; \
	fi
	@echo ""

.PHONY: auth-logout
auth-logout: ## 🚪 全サービスからログアウト
	@echo "🚪 認証情報削除"
	@echo "==============="
	@echo "⚠️  警告: 全ての認証情報を削除します"
	@echo ""
	@read -p "本当にログアウトしますか？ (yes/no): " confirm && [ "$$confirm" = "yes" ] || exit 1
	@echo ""
	@echo "🔄 Google Cloud認証削除中..."
	@gcloud auth revoke --all 2>/dev/null || true
	@echo "🔄 GitHub CLI認証削除中..."
	@gh auth logout 2>/dev/null || true
	@echo "🔄 Terraform Cloud認証削除中..."
	@rm -f ~/.terraform.d/credentials.tfrc.json 2>/dev/null || true
	@echo ""
	@echo "✅ ログアウト完了"
	@echo "💡 再ログイン: make setup-auth"
	@echo ""

.PHONY: setup-auth
setup-auth: login-gcloud set-gcp-project login-terraform ## 🚀 初回認証セットアップ (推奨順序)
	@echo "🎉 初回認証セットアップ完了！"
	@echo "============================"
	@echo "💡 次のステップ:"
	@echo "  make auth-status     # 認証状態確認"
	@echo "  make check-terraform-cloud # Terraform Cloud接続確認"
	@echo "  make init            # Terraform初期化"
	@echo "  make plan            # インフラ確認"
	@echo ""

# =============================================================================
# ヘルプ・情報表示
# =============================================================================

.PHONY: help
help: ## 🎯 利用可能なコマンド一覧を表示
	@echo ""
	@echo "🚀 Enterprise Infrastructure Management"
	@echo "======================================"
	@echo ""
	@echo "🔑 認証・ログイン:"
	@grep -E '^[a-zA-Z_-]*auth[a-zA-Z_-]*:.*?## .*$$|^[a-zA-Z_-]*login[a-zA-Z_-]*:.*?## .*$$|^[a-zA-Z_-]*set-gcp[a-zA-Z_-]*:.*?## .*$$|^[a-zA-Z_-]*setup-auth[a-zA-Z_-]*:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
	@echo ""
	@echo "📋 基本操作:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -v -E 'auth|login|set-gcp|setup-auth' | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
	@echo ""
	@echo "📖 クイックスタート (新規環境):"
	@echo "  make setup-auth      # 1. 認証セットアップ"
	@echo "  make init            # 2. Terraform初期化"
	@echo "  make plan            # 3. 変更内容確認"
	@echo "  make apply           # 4. 変更適用"
	@echo ""
	@echo "📖 日常運用:"
	@echo "  make auth-status     # 認証状態確認"
	@echo "  make plan            # 変更内容確認"
	@echo "  make apply           # 変更適用"
	@echo ""
	@echo "⚠️  注意: destroy は本番環境では絶対に使用しないでください"
	@echo ""

.PHONY: status
status: ## 📊 現在のプロジェクト状態を表示
	@echo "📊 プロジェクト状態"
	@echo "=================="
	@echo "環境: $(ENV)"
	@echo "Terraformディレクトリ: $(TERRAFORM_DIR)"
	@echo "現在のブランチ: $$(git branch --show-current)"
	@echo "最新コミット: $$(git log --oneline -1)"
	@echo ""
	@if [ -d "$(TERRAFORM_DIR)/.terraform" ]; then \
		echo "✅ Terraform初期化済み"; \
	else \
		echo "❌ Terraform未初期化 (make init を実行してください)"; \
	fi
	@echo ""

# =============================================================================
# 環境チェック・検証
# =============================================================================

.PHONY: check-env
check-env: ## 🔍 必要な環境・ツールの確認
	@echo "🔍 環境チェック"
	@echo "=============="
	@command -v terraform >/dev/null 2>&1 && echo "✅ Terraform: $$(terraform version | head -1)" || echo "❌ Terraform not found"
	@command -v git >/dev/null 2>&1 && echo "✅ Git: $$(git --version)" || echo "❌ Git not found"
	@command -v gcloud >/dev/null 2>&1 && echo "✅ gcloud: $$(gcloud version --format='value(Google Cloud SDK)' 2>/dev/null)" || echo "⚠️  gcloud not found (optional)"
	@echo ""
	@if [ ! -d "$(TERRAFORM_DIR)" ]; then \
		echo "❌ Terraformディレクトリが見つかりません: $(TERRAFORM_DIR)"; \
		exit 1; \
	fi

.PHONY: check-terraform-cloud
check-terraform-cloud: ## 🔍 Terraform Cloud接続確認
	@echo "🔍 Terraform Cloud接続確認"
	@echo "============================"
	@cd $(TERRAFORM_DIR) && \
	if terraform workspace list >/dev/null 2>&1; then \
		echo "✅ Terraform Cloud接続成功"; \
		echo "現在のWorkspace: $$(terraform workspace show)"; \
	else \
		echo "❌ Terraform Cloud接続失敗"; \
		echo "💡 terraform login を実行してください"; \
	fi
	@echo ""

# =============================================================================
# Terraform操作
# =============================================================================

.PHONY: init
init: check-env ## 🚀 Terraform初期化
	@echo "🚀 Terraform初期化"
	@echo "=================="
	@cd $(TERRAFORM_DIR) && terraform init
	@echo "✅ 初期化完了"
	@echo ""

.PHONY: validate
validate: ## ✅ Terraformコードの構文チェック
	@echo "✅ Terraformコード検証"
	@echo "====================="
	@cd $(TERRAFORM_DIR) && terraform validate
	@echo "✅ 構文チェック完了"
	@echo ""

.PHONY: format
format: ## 🎨 Terraformコードのフォーマット
	@echo "🎨 コードフォーマット"
	@echo "===================="
	@terraform fmt -recursive .
	@echo "✅ フォーマット完了"
	@echo ""

.PHONY: plan
plan: check-env ## 📋 インフラ変更計画の表示
	@echo "📋 Terraform Plan実行"
	@echo "===================="
	@echo "環境: $(ENV)"
	@echo "⏳ プラン作成中..."
	@echo ""
	@cd $(TERRAFORM_DIR) && terraform plan
	@echo ""
	@echo "✅ プラン実行完了"
	@echo "💡 変更を適用する場合は 'make apply' を実行してください"

.PHONY: apply
apply: check-env ## 🚀 インフラ変更の適用
	@echo "⚠️  インフラ変更を適用します"
	@echo "=========================="
	@echo "環境: $(ENV)"
	@echo ""
	@read -p "本当に適用しますか？ (yes/no): " confirm && [ "$$confirm" = "yes" ] || exit 1
	@echo ""
	@echo "⏳ 変更適用中..."
	@cd $(TERRAFORM_DIR) && terraform apply
	@echo ""
	@echo "✅ 変更適用完了"

.PHONY: destroy
destroy: check-env ## 🗑️ 全リソースの削除（危険！）
	@echo "🚨 警告: 全リソースを削除します"
	@echo "============================"
	@echo "この操作は元に戻せません！"
	@echo "環境: $(ENV)"
	@echo ""
	@read -p "本当に削除しますか？ (DELETE/no): " confirm && [ "$$confirm" = "DELETE" ] || exit 1
	@echo ""
	@echo "⏳ リソース削除中..."
	@cd $(TERRAFORM_DIR) && terraform destroy
	@echo ""
	@echo "✅ 削除完了"

# =============================================================================
# 開発・メンテナンス操作
# =============================================================================

.PHONY: clean
clean: ## 🧹 一時ファイル・キャッシュの削除
	@echo "🧹 クリーンアップ"
	@echo "==============="
	@find . -name ".terraform" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name ".terraform.lock.hcl" -type f -delete 2>/dev/null || true
	@find . -name "terraform.tfstate.backup" -type f -delete 2>/dev/null || true
	@echo "✅ クリーンアップ完了"
	@echo "💡 次回は 'make init' から始めてください"

.PHONY: security-check
security-check: ## 🔒 セキュリティチェック
	@echo "🔒 セキュリティチェック"
	@echo "===================="
	@echo "機密情報の確認中..."
	@if find . -name "*.tf" -o -name "*.tfvars" -o -name "*.json" | xargs grep -l "gcp-portfolio\|billing\|key" 2>/dev/null; then \
		echo "❌ 機密情報が見つかりました"; \
		exit 1; \
	else \
		echo "✅ 機密情報は検出されませんでした"; \
	fi
	@echo ""

.PHONY: docs
docs: ## 📚 ドキュメント生成
	@echo "📚 ドキュメント生成"
	@echo "=================="
	@echo "terraform-docs が必要です"
	@if command -v terraform-docs >/dev/null 2>&1; then \
		terraform-docs markdown table --output-file README_TERRAFORM.md $(TERRAFORM_DIR); \
		echo "✅ ドキュメント生成完了: README_TERRAFORM.md"; \
	else \
		echo "⚠️  terraform-docs がインストールされていません"; \
		echo "💡 インストール: https://terraform-docs.io/user-guide/installation/"; \
	fi

# =============================================================================
# Git操作ショートカット
# =============================================================================

.PHONY: git-status
git-status: ## 📊 Git状態確認
	@echo "📊 Git状態"
	@echo "==========="
	@git status --short
	@echo ""

.PHONY: commit-check
commit-check: format validate security-check ## ✅ コミット前チェック
	@echo "✅ コミット前チェック完了"
	@echo "git add . && git commit -m 'your message' でコミットできます"

# =============================================================================
# 緊急時・トラブルシューティング
# =============================================================================

.PHONY: emergency-info
emergency-info: ## 🚨 緊急時の情報表示
	@echo "🚨 緊急時情報"
	@echo "============"
	@echo "Terraform Cloud Organization: saitoscgm-portfolio"
	@echo "Workspace: gcp-portfolio-dev"
	@echo "Terraform Cloud URL: https://app.terraform.io/app/saitoscgm-portfolio"
	@echo ""
	@echo "🔧 よくある問題と解決策:"
	@echo "  terraform login - Terraform Cloud認証"
	@echo "  make clean && make init - 初期化やり直し"
	@echo "  git checkout -- . - ローカル変更の破棄"
	@echo ""

# =============================================================================
# 統合操作
# =============================================================================

.PHONY: all
all: check-env format validate plan ## 🎯 全体チェック（format + validate + plan）

# =============================================================================
# フォニーターゲット宣言
# =============================================================================

.PHONY: help status check-env check-terraform-cloud init validate format plan apply destroy
.PHONY: clean security-check docs git-status commit-check emergency-info all
.PHONY: login-gcloud login-gcloud-app login-terraform login-github set-gcp-project
.PHONY: auth-status auth-logout setup-auth
