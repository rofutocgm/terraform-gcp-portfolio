# =============================================================================
# GLOBAL OUTPUTS (グローバル出力値定義)
# =============================================================================
# このファイルでは、他のTerraformモジュールや外部から参照できる値を定義します

# ★★★ 重要：Environment Variableを明示的に取得する箇所 ★★★
# Google Cloudの現在の設定情報を取得するdata source
# この data source が以下の環境変数を自動で読み取ります：
# - GOOGLE_PROJECT (プロジェクトID)
# - GOOGLE_CREDENTIALS (認証情報)
# - GOOGLE_REGION (リージョン、設定されている場合)
data "google_client_config" "current" {
  # この {} の中は空ですが、Terraform実行時に以下が自動実行されます：
  # 1. GOOGLE_PROJECT 環境変数を読み取り
  # 2. GOOGLE_CREDENTIALS 環境変数で認証
  # 3. Google Cloud APIに接続
  # 4. 現在のプロジェクト情報を取得
}

# プロジェクトIDの出力
# ★★★ ここでEnvironment Variableの値が出力される ★★★
output "project_id" {
  description = "GCP Project ID (GOOGLE_PROJECT環境変数から取得)"
  # data.google_client_config.current.project = GOOGLE_PROJECT環境変数の値
  value       = data.google_client_config.current.project
  # 実行例：terraform apply後に "project_id = 'your-gcp-project-id'" と表示される
}

# リージョンの出力
output "region" {
  description = "GCP Region (変数から取得)"
  value       = var.region  # provider.tfで定義した変数から取得
  # 実行例："region = 'asia-northeast1'" と表示される
}

# ゾーンの出力
output "zone" {
  description = "GCP Zone (変数から取得)"
  value       = var.zone   # provider.tfで定義した変数から取得
  # 実行例："zone = 'asia-northeast1-a'" と表示される
}

# 環境名の出力
output "environment" {
  description = "Environment name (変数から取得)"
  value       = var.environment  # provider.tfで定義した変数から取得
  # 実行例："environment = 'dev'" と表示される
}