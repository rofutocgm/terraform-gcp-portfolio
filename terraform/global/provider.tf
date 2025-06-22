# =============================================================================
# GCP PROVIDER CONFIGURATION (Google Cloud接続設定)
# =============================================================================

# ★★★ 重要：Environment Variableが使われる箱所 ★★★
# Google Cloud Providerの設定
# projectパラメータを明示的に指定していないため、
# Google Providerが自動で以下の順序でプロジェクトIDを探します：
# 1. GOOGLE_PROJECT 環境変数 ←←← ここで使われる！
# 2. GOOGLE_APPLICATION_CREDENTIALS ファイル内のプロジェクトID
# 3. gcloud configの設定
# 4. GCEメタデータサーバー
provider "google" {
  # project = var.project_id  # ← この行がないことで環境変数が使われる
  region  = var.region        # リージョンは変数から取得
}

# Google Cloud Beta機能用Provider（新機能やプレビュー機能を使う場合）
provider "google-beta" {
  # project = var.project_id  # ← こちらも環境変数から自動取得
  region  = var.region
}

# =============================================================================
# PROJECT VARIABLES (プロジェクト変数定義)
# =============================================================================
# これらの変数は、Terraform CloudのWorkspaceで値を設定します

# 注意：project_id 変数は削除済み
# 理由：GOOGLE_PROJECT 環境変数を使用するため不要

# GCPリージョン設定
variable "region" {
  description = "GCP Region (例: asia-northeast1 = 東京リージョン)"
  type        = string
  default     = "asia-northeast1"  # 東京リージョンをデフォルトに設定
}

# GCPゾーン設定
variable "zone" {
  description = "GCP Zone (例: asia-northeast1-a = 東京リージョンのAゾーン)"
  type        = string
  default     = "asia-northeast1-a"
}

# 環境名設定（dev, staging, prodなど）
variable "environment" {
  description = "Environment name (環境名: dev=開発, staging=テスト, prod=本番)"
  type        = string
  default     = "dev"  # 開発環境をデフォルトに設定
}

# プロジェクト名設定（リソース名のプレフィックスに使用）
variable "project_name" {
  description = "Project name for resource naming (リソース名のプレフィックス用)"
  type        = string
  default     = "portfolio"  # 例: portfolio-dev-vpc, portfolio-dev-gke など
}