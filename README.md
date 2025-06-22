# 🚀 情シス転職ポートフォリオ - GCP Terraform プロジェクト

## 📋 プロジェクト概要

このリポジトリは、**情報システム部門（情シス）転職**を目指すためのポートフォリオプロジェクトです。  
GCPとTerraformを使用したIaC（Infrastructure as Code）により、実務レベルのモダンな社内システム基盤を構築します。

### 🎯 プロジェクトの目標
- **実務スキルの証明**: 企業で実際に使われる技術スタックの習得
- **モダンなインフラ管理**: Kubernetes・CI/CD・監視の実践
- **セキュリティ意識**: エンタープライズレベルのセキュリティ設計
- **チーム協業**: 複数人での開発を想定した構成管理

## 🏗️ アーキテクチャ

### システム構成（予定）
```
┌─────────────────────────────────────────────────────────────┐
│                     GCP プロジェクト                        │
│                                                             │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │                  GKE クラスター                          │  │
│  │  ┌─────────────────┐  ┌─────────────────┐                │  │
│  │  │  Frontend Pod   │  │  Backend API    │                │  │
│  │  │ ・社内ポータル  │  │ ・認証サービス  │                │  │
│  │  └─────────────────┘  └─────────────────┘                │  │
│  └─────────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │              セキュリティ・監視層                       │  │
│  │  ・VPC (プライベートネットワーク)                      │  │
│  │  ・IAM (最小権限の原則)                                │  │
│  │  ・Cloud Monitoring (メトリクス・アラート)            │  │
│  └─────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 🛠️ 技術スタック

### インフラストラクチャ
- **クラウド**: Google Cloud Platform (GCP)
- **IaC**: Terraform + Terraform Cloud
- **コンテナ**: Google Kubernetes Engine (GKE)
- **ネットワーク**: VPC, Cloud Load Balancer
- **ストレージ**: Cloud Storage, Cloud SQL

### 開発・運用
- **CI/CD**: Cloud Build, GitHub Actions
- **監視**: Cloud Monitoring, Cloud Logging
- **セキュリティ**: IAM, VPC, Security Command Center

## 📁 プロジェクト構成

```
terraform-gcp-portfolio/
├── 📚 README.md                          # このファイル
├── 📋 docs/                             # ドキュメント
│
├── 🏗️ terraform/                        # インフラコード
│   ├── 🌍 global/                       # グローバル設定（完成）
│   │   ├── backend.tf                   # Terraform Cloud設定
│   │   ├── provider.tf                  # GCPプロバイダー設定
│   │   └── outputs.tf                   # 出力値定義
│   │
│   ├── 🌐 network/                      # ネットワーク設定（予定）
│   ├── 🚀 gke/                          # Kubernetesクラスター（予定）
│   ├── 💾 storage/                      # ストレージ（予定）
│   ├── 🔐 security/                     # セキュリティ（予定）
│   └── 📊 monitoring/                   # 監視（予定）
│
├── 🐳 applications/                     # アプリケーション（予定）
├── 🔄 cicd/                             # CI/CDパイプライン（予定）
└── 🧪 tests/                            # テスト（予定）
```

## 🚀 セットアップ手順

### 前提条件
- GCPアカウント
- Terraform Cloud アカウント
- Git / GitHub

### 1. リポジトリクローン
```bash
git clone https://github.com/YOUR_USERNAME/terraform-gcp-portfolio.git
cd terraform-gcp-portfolio
```

### 2. Terraform Cloud 設定
1. [Terraform Cloud](https://app.terraform.io) でアカウント作成
2. Organization と Workspace を作成
3. Environment Variables を設定:
   - `GOOGLE_CREDENTIALS`: GCPサービスアカウントキー（JSON）
   - `GOOGLE_PROJECT`: GCPプロジェクトID

### 3. 基本設定のデプロイ
```bash
cd terraform/global
terraform init
terraform plan
terraform apply
```

## 📈 実装ロードマップ

### ✅ Phase 1: 基盤構築（完了）
- [x] Terraform Cloud セットアップ
- [x] GCP認証・接続設定
- [x] 基本的なProvider設定

### 🔄 Phase 2: ネットワーク構築（次回）
- [ ] VPC・サブネット作成
- [ ] ファイアウォールルール設定
- [ ] セキュリティ設定

### ⏳ Phase 3: アプリケーション基盤（予定）
- [ ] GKEクラスター構築
- [ ] Cloud SQL・Redis設定
- [ ] CI/CDパイプライン構築

### ⏳ Phase 4: 監視・運用（予定）
- [ ] 監視・ログ設定
- [ ] アラート設定
- [ ] 運用ドキュメント作成

## 💡 転職面接でのアピールポイント

### 技術スキル
- **現代的な技術スタック**: Terraform, Kubernetes, CI/CDの実践経験
- **クラウドネイティブ**: GCPサービスの活用
- **セキュリティ意識**: IAM、VPCなどのセキュリティ設計

### 実務適用力
- **責任分離**: モジュール化された管理しやすい構成
- **チーム開発**: 複数人での並行作業を考慮した設計
- **運用重視**: 監視・ログ・トラブルシューティングまで考慮

### ソフトスキル
- **ドキュメント化**: 設計思想・運用手順の整備
- **継続的改善**: CI/CDによる自動化・品質向上
- **コスト意識**: 効率的なリソース利用

## 📞 お問い合わせ

このプロジェクトに関する質問やフィードバックがございましたら、お気軽にお問い合わせください。

---

**作成者**: [あなたの名前]  
**作成日**: 2025年6月22日  
**目的**: 情シス転職ポートフォリオ
