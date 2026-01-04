# オトクダ (Shopping Assistant)

複数のECサイトから商品を横断検索し、最安値を見つけるモバイルアプリです。

## 機能

- **横断検索**: Amazon、楽天市場、Yahoo!ショッピングの商品を一括検索
- **実質価格比較**: ポイント還元・送料を考慮した実質価格で比較
- **スマートソート**: 価格順、ポイント順、レビュー順でソート
- **フィルタリング**: 価格帯、送料無料、在庫ありで絞り込み

## スクリーンショット

*開発中*

## 技術スタック

- **Flutter** - クロスプラットフォームモバイル開発
- **Riverpod** - 状態管理
- **Dio** - HTTPクライアント
- **Freezed** - イミュータブルデータモデル

## 対応API

| ECサイト | API | ステータス |
|----------|-----|-----------|
| Amazon | Product Advertising API 5.0 | 対応済み |
| 楽天市場 | 楽天商品検索API | 対応済み |
| Yahoo!ショッピング | ショッピングWeb API | 対応済み |

## セットアップ

### 必要要件

- Flutter 3.10以上
- FVM (Flutter Version Management) 推奨

### インストール

```bash
# リポジトリをクローン
git clone https://github.com/hirotaka-iwasaki/shopping-assistant.git
cd shopping-assistant

# FVMでFlutterをセットアップ
fvm install
fvm use

# 依存関係をインストール
fvm flutter pub get

# コード生成
fvm dart run build_runner build

# アプリを実行
fvm flutter run
```

### 環境変数

`.env.example` をコピーして `.env` を作成し、APIキーを設定してください：

```bash
cp .env.example .env
```

## アフィリエイトについて

本アプリはアフィリエイトプログラムを利用しています：

- Amazonアソシエイト・プログラム
- 楽天アフィリエイト
- バリューコマース（Yahoo!ショッピング）

商品リンクから購入された場合、アプリ運営者に報酬が支払われることがあります。
これによりユーザーに追加費用が発生することはありません。

## ライセンス

MIT License

## 開発者

Hirotaka Iwasaki
