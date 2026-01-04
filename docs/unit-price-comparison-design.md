# 単価比較機能 実装設計書

## 概要

商品の容量・数量が異なる場合でも、単価（100gあたり、1個あたり等）で比較できる機能を実装する。

### 解決したい課題

```
例: コーヒー豆を検索した場合

商品A: AGF ちょっと贅沢な珈琲店 1kg        → ¥1,980
商品B: AGF ちょっと贅沢な珈琲店 200g×3袋   → ¥1,680

表示価格だけでは比較できない
↓
単価換算: 商品A ¥198/100g vs 商品B ¥280/100g
→ 商品Aがお得と判断可能
```

---

## 技術調査結果

### API提供データの現状

| ECサイト | 構造化された容量データ | 代替手段 |
|---------|---------------------|---------|
| Amazon | なし | `ItemInfo.Features`（特徴リスト） |
| 楽天 | なし | `itemName`, `itemCaption` |
| Yahoo | なし | `name`, `description` |

**結論: 全APIで構造化された容量・数量データは提供されていない**

### 抽出対象フィールド

| サイト | 主要フィールド | 補助フィールド |
|-------|--------------|---------------|
| Amazon | title | ItemInfo.Features（箇条書き） |
| 楽天 | itemName | itemCaption（商品説明） |
| Yahoo | name | description |

---

## 実装アプローチ

### 採用方針: ハイブリッド方式

```
┌─────────────────────────────────────────────────────────┐
│                    商品データ入力                         │
│              (title + description)                       │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  Phase 1: 正規表現による高速抽出                          │
│  - コストゼロ、即時処理                                   │
│  - 想定カバー率: 60-70%                                  │
└─────────────────────────┬───────────────────────────────┘
                          ▼
                 ┌────────┴────────┐
                 │   抽出成功?      │
                 └────────┬────────┘
                    Yes   │   No
                     ▼    │    ▼
┌────────────────────┐    │   ┌────────────────────────────┐
│ 単価計算           │    │   │ Phase 2: LLM補完解析        │
│ 信頼度: High       │    │   │ - バッチ処理でコスト最適化   │
│ 即時表示           │    │   │ - キャッシュ活用            │
└────────────────────┘    │   └─────────────┬──────────────┘
                          │                 ▼
                          │   ┌────────────────────────────┐
                          │   │ 単価計算                    │
                          │   │ 信頼度: Medium              │
                          │   └────────────────────────────┘
                          │                 │
                          │   抽出失敗時    ▼
                          │   ┌────────────────────────────┐
                          │   │ 「単価不明」表示             │
                          │   │ ユーザー手動入力オプション   │
                          │   └────────────────────────────┘
```

---

## Phase 1: 正規表現抽出（MVP）

### 対応パターン

#### 重量系
```dart
// パターン例
'500g', '500グラム', '1kg', '1キロ', '1.5kg'

// 正規表現
r'(\d+(?:\.\d+)?)\s*(g|グラム|kg|キロ(?:グラム)?)'
```

#### 容量系
```dart
// パターン例
'500ml', '500ミリリットル', '2L', '2リットル', '350cc'

// 正規表現
r'(\d+(?:\.\d+)?)\s*(ml|ミリリットル|cc|l|リットル)'
```

#### 個数系
```dart
// パターン例
'3個入り', '6本セット', '12缶', '24袋入', '2パック'

// 正規表現
r'(\d+)\s*(個|本|袋|缶|枚|パック|セット|入り?|箱|巻)'
```

#### 複合系（最も重要）
```dart
// パターン例
'500g×3袋', '2L×6本', '100ml×12本'

// 正規表現
r'(\d+(?:\.\d+)?)\s*(g|kg|ml|l)\s*[×xX✕]\s*(\d+)'
```

### 単位正規化ルール

| 入力単位 | 正規化単位 | 変換係数 |
|---------|-----------|---------|
| g, グラム | g | 1 |
| kg, キロ | g | 1000 |
| ml, ミリリットル, cc | ml | 1 |
| L, リットル | ml | 1000 |
| 個, 本, 袋, 缶, 枚 | 個 | 1 |
| セット, パック, 箱 | 個 | 1（内容個数を抽出） |

### データモデル拡張

```dart
/// 単位情報を表すクラス
@freezed
class UnitInfo with _$UnitInfo {
  const factory UnitInfo({
    /// 数値 (例: 500)
    required double quantity,

    /// 単位 (例: "g", "ml", "個")
    required String unit,

    /// セット数 (例: 3) - 「500g×3袋」の3
    @Default(1) int packCount,

    /// 総量 (例: 1500) - quantity × packCount
    required double totalQuantity,

    /// 正規化後の単位 (例: "g", "ml", "個")
    required String normalizedUnit,

    /// 抽出方法
    required ExtractMethod method,

    /// 信頼度 (0.0 - 1.0)
    required double confidence,
  }) = _UnitInfo;

  const UnitInfo._();

  factory UnitInfo.fromJson(Map<String, dynamic> json) =>
      _$UnitInfoFromJson(json);

  /// 単価計算 (例: 100gあたり、100mlあたり)
  double calculateUnitPrice(int price, {int per = 100}) {
    if (totalQuantity <= 0) return 0;
    return (price / totalQuantity) * per;
  }

  /// 表示用文字列 (例: "¥198/100g")
  String formatUnitPrice(int price) {
    final unitPrice = calculateUnitPrice(price);
    final perUnit = normalizedUnit == '個' ? '1個' : '100$normalizedUnit';
    return '¥${unitPrice.round()}/$perUnit';
  }
}

enum ExtractMethod {
  regex,      // 正規表現抽出
  llm,        // LLM解析
  userInput,  // ユーザー入力
  cached,     // キャッシュから取得
  unknown,    // 抽出失敗
}
```

### Productモデル拡張

```dart
@freezed
class Product with _$Product {
  const factory Product({
    // ... 既存フィールド ...

    /// 単位情報（単価計算用）
    UnitInfo? unitInfo,
  }) = _Product;

  const Product._();

  /// 単価（100g/100ml/1個あたり）
  double? get unitPrice {
    if (unitInfo == null) return null;
    return unitInfo!.calculateUnitPrice(effectivePrice);
  }

  /// 単価表示文字列
  String? get formattedUnitPrice {
    if (unitInfo == null) return null;
    return unitInfo!.formatUnitPrice(effectivePrice);
  }
}
```

---

## Phase 2: LLM補完解析

### 対象ケース

正規表現で抽出できないパターン：

1. **曖昧な表現**: 「大容量」「増量版」「お徳用」
2. **ネスト構造**: 「1箱（12本入り）」
3. **テキスト内埋め込み**: 「内容量は500gです」
4. **単位なし数値**: 「コーヒー豆 500」

### LLM API選定

| モデル | 1商品あたりコスト | 速度 | 精度 |
|-------|-----------------|------|------|
| Claude Haiku | ~¥0.03 | 速い | 高 |
| GPT-4o-mini | ~¥0.02 | 速い | 高 |
| GPT-3.5-turbo | ~¥0.01 | 最速 | 中 |

**推奨: Claude Haiku または GPT-4o-mini**

### プロンプト設計

```
以下の商品情報から、内容量・数量を抽出してJSON形式で返してください。

商品名: {title}
商品説明: {description}

出力形式:
{
  "quantity": 数値,
  "unit": "g" | "kg" | "ml" | "L" | "個" | "本" | "袋" など,
  "pack_count": セット数（デフォルト1）,
  "total_quantity": 総量,
  "normalized_unit": "g" | "ml" | "個",
  "confidence": 0.0-1.0
}

抽出できない場合:
{
  "quantity": null,
  "confidence": 0
}
```

### バッチ処理最適化

```dart
/// 複数商品を一括でLLM解析
class LlmUnitExtractor {
  static const int batchSize = 10;

  Future<List<UnitInfo?>> extractBatch(List<Product> products) async {
    // 10商品ずつバッチ処理
    final batches = products.chunked(batchSize);
    final results = <UnitInfo?>[];

    for (final batch in batches) {
      final batchResults = await _processBatch(batch);
      results.addAll(batchResults);
    }

    return results;
  }
}
```

### キャッシュ戦略

```dart
/// 商品タイトルをキーにしたキャッシュ
class UnitInfoCache {
  // メモリキャッシュ（セッション中）
  final Map<String, UnitInfo> _memoryCache = {};

  // 永続キャッシュ（SharedPreferences）
  Future<UnitInfo?> get(String productTitle) async {
    // 1. メモリキャッシュをチェック
    if (_memoryCache.containsKey(productTitle)) {
      return _memoryCache[productTitle];
    }

    // 2. 永続キャッシュをチェック
    final cached = await _loadFromStorage(productTitle);
    if (cached != null) {
      _memoryCache[productTitle] = cached;
      return cached;
    }

    return null;
  }

  Future<void> set(String productTitle, UnitInfo info) async {
    _memoryCache[productTitle] = info;
    await _saveToStorage(productTitle, info);
  }
}
```

---

## Phase 3: 高度化（将来）

### カテゴリ別単位最適化

| カテゴリ | 推奨比較単位 | 表示例 |
|---------|------------|-------|
| 飲料 | 100ml | ¥15/100ml |
| コーヒー・茶葉 | 100g | ¥198/100g |
| 米・穀物 | 1kg | ¥398/kg |
| 洗剤 | 回数 or 100ml | ¥8/回 |
| ティッシュ | 枚 | ¥0.5/枚 |
| 電池 | 1本 | ¥50/本 |

### JANコード活用

```dart
/// 同一JANコードの商品をグループ化
class ProductMatcher {
  Map<String, List<Product>> groupByJan(List<Product> products) {
    final groups = <String, List<Product>>{};

    for (final product in products) {
      if (product.janCode != null) {
        groups.putIfAbsent(product.janCode!, () => []);
        groups[product.janCode!]!.add(product);
      }
    }

    return groups;
  }
}
```

### ユーザー補正機能

```dart
/// ユーザーが手動で容量を入力
class UserUnitInput {
  Future<UnitInfo> promptUser(Product product) async {
    // ダイアログで入力を求める
    // 入力結果をキャッシュに保存
  }
}
```

---

## UI/UX設計

### 設計方針

**目標:**
- 一覧性を高める（情報を最小限に）
- 詳細へのアクセスは簡単に（詳細ページを開かなくてよい）

**採用パターン:** Progressive Disclosure（段階的開示）
- トグル式リストで初期状態はコンパクト
- タップで展開して詳細表示

---

### 商品リスト表示

#### 折りたたみ状態（デフォルト）

```
┌─────────────────────────────────────────────────────────┐
│ [IMG]  AGF ちょっと贅沢な珈琲店 1kg             [▼]     │
│        実質 ¥1,880          ¥188/100g                  │
└─────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────┐
│ [IMG]  AGF ちょっと贅沢な珈琲店 200g×3袋        [▼]     │
│        実質 ¥1,580          ¥263/100g                  │
└─────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────┐
│ [IMG]  UCC ゴールドスペシャル 400g×2袋          [▼]     │
│        実質 ¥1,280          ¥160/100g                  │
└─────────────────────────────────────────────────────────┘
```

**表示要素（折りたたみ時）:**
| 要素 | 説明 |
|-----|------|
| 商品画像 | サムネイル（小） |
| 商品名 | 1行、省略あり |
| 実質価格 | 送料・ポイント考慮済み |
| 単価 | 100gあたり等 |
| 展開ボタン | [▼] |

**非表示（折りたたみ時）:**
- 元価格、送料詳細、ポイント詳細
- レビュー情報、店舗名、ECサイトアイコン

---

#### 展開状態（タップ後）

```
┌─────────────────────────────────────────────────────────┐
│ [IMG]  AGF ちょっと贅沢な珈琲店 1kg             [▲]     │
│        実質 ¥1,880          ¥188/100g                  │
│ ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄ │
│  価格       ¥1,980                                     │
│  送料       無料（Prime対象）                           │
│  ポイント    100pt 還元                                 │
│  レビュー    ★4.5 (1,234件)                            │
│  販売元     Amazon.co.jp                               │
│                                                        │
│  ┌──────────────────────────────────────────────────┐  │
│  │      [Amazon] 商品ページを開く →                  │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

**追加表示要素（展開時）:**
| 要素 | 説明 |
|-----|------|
| 元価格 | 税込価格 |
| 送料詳細 | 無料/有料/条件付き |
| ポイント還元 | 金額・倍率 |
| レビュー | 星評価・件数 |
| 販売元 | 店舗名 |
| リンクボタン | 商品ページへ遷移 |

---

### インタラクション

| 操作 | 動作 |
|-----|------|
| カード全体タップ | 展開/折りたたみトグル |
| リンクボタンタップ | 外部ブラウザで商品ページを開く |
| スワイプ | リストスクロール |

---

### 単価の信頼度表示

| 信頼度 | 表示 | 説明 |
|-------|-----|------|
| High (≥0.9) | `¥188/100g` | 明確なパターンマッチ |
| Medium (0.5-0.9) | `¥188/100g *` | LLM推測（※注釈付き） |
| Low (<0.5) | `単価 -` | 抽出失敗 |

---

### ソートオプション

```dart
enum SortOption {
  unitPriceAsc,   // 単価が安い順（デフォルト推奨）
  priceAsc,       // 実質価格が安い順
  priceDesc,      // 実質価格が高い順
  relevance,      // 関連度順
  reviewDesc,     // レビューが多い順
}
```

---

### フィルター

```dart
class SearchQuery {
  // ... 既存フィールド ...

  /// 単価範囲フィルター（100gあたり）
  double? minUnitPrice;
  double? maxUnitPrice;

  /// 単価が計算可能な商品のみ表示
  bool unitPriceAvailableOnly = false;
}
```

---

### Widgetコンポーネント構成

```
ProductListView
├── ProductCard (StatefulWidget)
│   ├── _CollapsedContent
│   │   ├── ProductThumbnail
│   │   ├── ProductTitle (1行)
│   │   ├── EffectivePriceLabel
│   │   └── UnitPriceLabel
│   │
│   └── _ExpandedContent
│       ├── PriceRow
│       ├── ShippingRow
│       ├── PointRow
│       ├── ReviewRow
│       ├── SellerRow
│       └── OpenLinkButton
│
└── SortFilterBar
```

### 実装方法

```dart
// ExpansionTile を使用した実装例
class ProductCard extends StatelessWidget {
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: ProductThumbnail(url: product.imageUrl),
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Text('実質 ${product.formattedEffectivePrice}'),
            const Spacer(),
            if (product.formattedUnitPrice != null)
              Text(product.formattedUnitPrice!),
          ],
        ),
        children: [
          _ExpandedContent(product: product),
        ],
      ),
    );
  }
}
```

---

## 実装スケジュール

### Phase 1: MVP（正規表現のみ）

**対象:**
- [ ] UnitInfoモデル作成
- [ ] 正規表現パーサー実装
- [ ] Productモデル拡張
- [ ] 単価表示UI
- [ ] 単価ソート機能

**想定工数:** 2-3日

### Phase 2: LLM補完

**対象:**
- [ ] LLM API連携
- [ ] バッチ処理実装
- [ ] キャッシュ機構
- [ ] 信頼度表示UI

**想定工数:** 3-5日

### Phase 3: 高度化

**対象:**
- [ ] カテゴリ別単位最適化
- [ ] JANコードマッチング
- [ ] ユーザー補正機能

**想定工数:** 5-7日

---

## リスクと対策

| リスク | 影響 | 対策 |
|-------|-----|------|
| 正規表現の精度不足 | 誤った単価表示 | 信頼度表示、ユーザー報告機能 |
| LLM APIコスト増大 | 運用コスト上昇 | キャッシュ徹底、バッチ処理 |
| 表記ゆれの多さ | カバー率低下 | パターン追加、LLM補完 |
| 複合単位の解析失敗 | 主要ケースで失敗 | 複合パターン優先実装 |

---

## 参考資料

- [Amazon PA-API v5 Resources](https://webservices.amazon.com/paapi5/documentation/resources.html)
- [楽天市場商品検索API](https://webservice.rakuten.co.jp/documentation/ichiba-item-search)
- [Yahoo!ショッピング商品検索API v3](https://developer.yahoo.co.jp/webapi/shopping/v3/itemsearch.html)
- [ChatGPT Deep Research結果](https://chatgpt.com/s/dr_695a6d01fad08191b3fdb95dd0a08fc6)
