# =============================================================================
# TERRAFORM BACKEND CONFIGURATION (Terraform Cloud設定)
# =============================================================================
# このファイルは、Terraformの「状態ファイル」をどこに保存するかを定義します
# 状態ファイル = Terraformが管理しているリソースの現在の状況を記録したファイル

terraform {
  # Terraform Cloudを使用する設定
  # ローカルファイルではなく、クラウド上で状態ファイルを管理
  cloud {
    # あなたのTerraform Cloud組織名
    # https://app.terraform.io で作成した組織
    organization = "saitoscgm-portfolio"
    
    # Workspace = プロジェクトの環境（dev, staging, prodなど）
    workspaces {
      name = "gcp-portfolio-dev"  # 開発環境用workspace
    }
  }
  
  # 使用するTerraformのバージョン制限
  # ">= 1.8" = バージョン1.8以上を要求
  required_version = ">= 1.8"
  
  # 使用するProvider（各クラウドサービスとの接続ライブラリ）の定義
  required_providers {
    # Google Cloud Platform用のProvider
    google = {
      source  = "hashicorp/google"      # Providerの提供元
      version = "~> 6.0"                # バージョン6.x系を使用
    }
    # Google Cloud Beta機能用のProvider（新機能をテストする際に使用）
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.0"
    }
  }
}