#!/bin/bash

# Terraform Cloud用のGCP Service Account作成スクリプト
# 使用前にGCP_PROJECT_IDを設定してください

echo "🚀 Terraform Cloud用GCP Service Account設定開始"

# プロジェクトID設定（実際のプロジェクトIDに変更）
read -p "GCPプロジェクトIDを入力してください: " GCP_PROJECT_ID

if [ -z "$GCP_PROJECT_ID" ]; then
    echo "❌ プロジェクトIDが入力されていません"
    exit 1
fi

echo "📋 使用するプロジェクト: $GCP_PROJECT_ID"

# プロジェクト設定
gcloud config set project $GCP_PROJECT_ID

# Service Account作成
echo "🔧 Service Account作成中..."
gcloud iam service-accounts create terraform-cloud-sa \
    --display-name="Terraform Cloud Service Account" \
    --description="Service Account for Terraform Cloud automation"

# 必要な権限を付与
echo "🔐 権限設定中..."
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
    --member="serviceAccount:terraform-cloud-sa@$GCP_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/editor"

gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
    --member="serviceAccount:terraform-cloud-sa@$GCP_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountAdmin"

gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
    --member="serviceAccount:terraform-cloud-sa@$GCP_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/resourcemanager.projectIamAdmin"

# Service Account Key作成
echo "🔑 Service Account Key作成中..."
gcloud iam service-accounts keys create ./terraform-cloud-key.json \
    --iam-account=terraform-cloud-sa@$GCP_PROJECT_ID.iam.gserviceaccount.com

echo "✅ Service Account設定完了！"
echo ""
echo "📝 次のステップ:"
echo "1. terraform-cloud-key.json の内容をコピー"
echo "2. Terraform CloudのWorkspaceでEnvironment Variablesに設定"
echo ""
echo "🔧 設定する環境変数:"
echo "- GOOGLE_CREDENTIALS (terraform-cloud-key.json の内容)"
echo "- GOOGLE_PROJECT ($GCP_PROJECT_ID)"
echo ""
