# CLAUDE.md - Shopping Assistant Project Guidelines

## プロジェクト概要

Flutterで構築するマルチサイト価格比較ショッピングアプリ。Amazon、楽天市場、Yahoo!ショッピング、Qoo10の商品を横断検索し、実質価格で比較できるアプリケーション。

> 📋 **実装TODO**: 詳細な実装タスクは [TODO.md](./TODO.md) を参照

## 対応ECプラットフォーム

### Amazon (Product Advertising API)
- **要件**: AWSアカウント + Associatesプログラム登録
- **取得データ**: 商品名、価格、ASIN、画像URL、レビュー
- **レート制限**: 初期1req/sec、売上に応じて最大10req/secまで増加
- **アフィリエイト**: Associate tagをAPIリクエストに必須で含める

### 楽天市場 (Rakuten Web Service)
- **要件**: 開発者登録 + 楽天アフィリエイトID
- **取得データ**: 商品名、価格、店舗情報、画像、ポイント倍率
- **レート制限**: 1req/sec/アプリケーションID
- **特記**: postageFlag（送料）、pointRate（ポイント倍率）を活用

### Yahoo!ショッピング
- **要件**: Yahoo!デベロッパーネットワーク登録 + ValueCommerce ID
- **取得データ**: 価格、送料コード、ジャンル、画像URL、ポイント構造
- **レート制限**: 約1query/sec
- **特記**: 詳細な送料コード（無料/条件付き無料）、詳細なポイントデータ

### Qoo10
- **APIステータス**: 公開APIなし
- **代替手段**: Webスクレイピング（Apify等）
- **リスク**: IPブロック、利用規約違反、サイト構造変更への対応

## 技術アーキテクチャ

### HTTPクライアント
**Dio** パッケージを使用:
- 自動シリアライズ/デシリアライズ
- ヘッダー管理・ログ用インターセプター
- リトライロジック・タイムアウト処理
- サービスごとのベースURL設定

### 状態管理
**Riverpod** を採用:
- `FutureProvider`: 非同期API呼び出し
- `StateProvider`: ユーザー設定（選択サイト等）
- 自動依存関係追跡と再ビルド最適化

### レイヤード構造
```
lib/
├── data/
│   ├── clients/          # 各EC APIクライアント (Amazon/Rakuten/Yahoo/Qoo10)
│   ├── models/           # データモデル
│   └── repositories/     # リポジトリ層（Future.waitで並列検索）
├── domain/
│   └── services/         # ビジネスロジック、バリデーション、結果集約
├── presentation/
│   ├── providers/        # Riverpodプロバイダー
│   ├── screens/          # 画面
│   └── widgets/          # UIコンポーネント
└── core/
    ├── config/           # 設定・定数
    └── utils/            # ユーティリティ
```

### 並列検索実装
`Future.wait()` で複数APIを同時実行。個別のエラーは握り潰さず、失敗したサイトは空結果を返しつつ他のサイトの結果は保持する。

## 主要機能設計

### サイト選択トグル
- `shared_preferences` でユーザー設定を永続化
- `StateProvider` でリアクティブに更新
- UI: 設定画面でチェックボックスまたはトグルスイッチ

### 価格比較ロジック
**実質価格（effectivePrice）** モデル:
```dart
effectivePrice = basePrice + shippingCost - pointValue
// pointValueは1ポイント=1円として計算（楽天/Yahoo）
```

- ソート: デフォルトは実質価格昇順
- フィルター: 価格範囲、送料無料、ポイント倍率

### データ正規化の注意点
- Amazon: 明示的な送料データなし → Prime=送料無料フラグとして扱う
- Qoo10: 表示データに限定

## 将来拡張: 画像検索
- 全APIが画像URLを返すためサムネイル表示可能
- Vision API (Google ML Kit, AWS Rekognition) で写真から検索キーワード自動生成
- APIコスト考慮が必要

## セキュリティ・コンプライアンス

### APIキー保護
- **絶対にリポジトリにコミットしない**
- `flutter_secure_storage` でランタイムアクセス
- `--dart-define` でビルド時注入
- 機密性の高い認証情報（Amazon秘密鍵等）はバックエンドプロキシ推奨

### プラットフォーム固有要件
- **iOS**: App Transport SecurityによりHTTPS必須（対象エンドポイントは全て対応済み）
- **Android**: Network Security ConfigでHTTPS許可、マニフェストにInternet permission必要

### 法規制・規約遵守
- アフィリエイト表記: About/ヘルプセクションに開示必須
- 公式ロゴ: 許可なく埋め込まない（商標リスク）
- スクレイピング: 利用規約違反・法的リスクあり
- データ利用: アフィリエイト目的に限定、画像は直接リンク表示（ローカル保存しない）

## エラーハンドリング戦略

- 個別APIエラーをキャッチし、ログ記録後に部分的結果を返す
- エラー種別を区別: ネットワーク不可、レート制限超過、無効なAPIキー
- UI: サイトごとのステータス表示（例: 「Amazonデータ取得不可。30秒後にリトライ」）
- ユーザー起動のリトライ機能を提供

## テスト・デプロイ

### テスト
- ユニットテスト: APIレスポンスをモック化
- VCR形式の記録済みHTTPインタラクション検討
- 商品比較のMarkdown出力を検証

### デプロイ時の注意
- 開発中のAPIクォータ使用量を監視（サービス停止回避）
- マルチサービス統合の複雑さを考慮し段階的ロールアウト推奨

## 開発時のコマンド

```bash
# 依存関係インストール
flutter pub get

# コード生成（freezed, json_serializable等）
flutter pub run build_runner build --delete-conflicting-outputs

# テスト実行
flutter test

# ビルド（環境変数注入）
flutter build apk --dart-define=AMAZON_ACCESS_KEY=xxx --dart-define=RAKUTEN_APP_ID=xxx

# 開発サーバー起動
flutter run
```

## 参考資料

- [Amazon Product Advertising API](https://webservices.amazon.com/paapi5/documentation/)
- [楽天ウェブサービス](https://webservice.rakuten.co.jp/)
- [Yahoo!デベロッパーネットワーク](https://developer.yahoo.co.jp/)
- [Apify (Qoo10スクレイピング)](https://apify.com/)
