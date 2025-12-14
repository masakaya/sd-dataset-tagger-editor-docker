# LoRAトレーニング用タグ付けガイド

Stable Diffusion LoRAトレーニングにおけるタグ付け（キャプション）の意味とテクニックを解説します。

このガイドを読むことで、LoRAがより意図通りに、そして柔軟に画像を生成できるようになります。

---

## 目次

1. [タグとは](#タグとは)
2. [タグの基本フォーマット](#タグの基本フォーマット)
3. [トリガーワード](#トリガーワードレアトークン)
4. [タグ付けすべき要素](#タグ付けすべき要素)
5. [タグの粒度と正規化](#タグの粒度と正規化)
6. [データセット作成のベストプラクティス](#データセット作成のベストプラクティス)
7. [WD Taggerの活用](#wd-taggerの活用)
8. [よくある問題と解決策](#よくある問題と解決策)
9. [参考リンク](#参考リンク)

---

## タグとは

タグは、画像の内容をテキストで説明したものです。LoRAトレーニングでは、モデルが「どの特徴を学習すべきか」を理解するための重要な情報源となります。

**重要**: 50枚の適切にタグ付けされた画像は、150枚の不適切なタグ付け画像より優れたLoRAを作成します。

### なぜタグが重要なのか

#### 1. 特徴の分離と制御

タグ付けされていない要素は「キャラクターと一体化」して学習されます。

**例**: すべての画像でキャラクターが帽子を被っている場合

| タグ付け | 結果 |
|---------|-----|
| なし | 帽子がキャラクターと一体化して学習される。帽子を脱がせた画像を生成しようとしても、キャラクターに帽子が固定されてしまう |
| `hat` をタグ付け | 帽子なしの画像も生成可能に |

#### 2. 生成時の制御性向上

タグ付けした要素は、生成時にプロンプトで制御できます。ネガティブプロンプトでの除外も可能です。

**例**:
- `red lipstick` をタグ付け → プロンプトで口紅の有無を制御可能
- `blurry background` をタグ付け → ネガティブプロンプトで背景ぼかしを抑制可能

---

## タグの基本フォーマット

### Danbooru形式（SD1.5/SDXL推奨）

```
[トリガーワード], [被写体の説明], [スタイル/品質タグ]
```

**例**:
```
mycharacter, 1girl, long blonde hair, blue eyes, white dress, standing, simple background, high quality
```

### 自然言語形式（Flux向け）

```
A photo of [被写体の詳細な説明]
```

**例**:
```
A photo of a young woman with long blonde hair wearing a blue dress, sitting in a cafe
```

---

## トリガーワード（レアトークン）

### トリガーワードとは

学習対象を識別するための固有のキーワードです。モデルが既存の知識と混同しないよう、珍しい単語を使用します。

### 位置の重要性

トリガーワードの位置が、何に関連付けられるかを決定します。

| タグ | 関連付け |
|-----|---------|
| `photo of skw man wearing a suit` | `skw` は人物に関連 |
| `photo of a man wearing skw suit` | `skw` はスーツに関連 |

### 推奨フォーマット

- **キャラクター**: `skw_charactername` または `ohwx person`
- **スタイル**: `in skw style` または `skw_stylename`
- **コンセプト**: `skw_concept`

---

## タグ付けすべき要素

### 必須でタグ付けすべきもの

| カテゴリ | 例 |
|---------|---|
| 人数 | `1girl`, `1boy`, `solo`, `multiple girls` |
| 視点・アングル | `from above`, `from side`, `close-up`, `full body`, `portrait` |
| 服装 | `white shirt`, `blue jeans`, `red hat`, `school uniform` |
| 髪型・髪色 | `long hair`, `blonde hair`, `ponytail`, `twintails` |
| 目の色 | `blue eyes`, `red eyes`, `heterochromia` |
| 表情 | `smile`, `serious`, `looking at viewer`, `closed eyes` |
| ポーズ | `standing`, `sitting`, `arms crossed`, `hand on hip` |
| 背景 | `outdoors`, `city background`, `simple background`, `white background` |

### 画像の欠点もタグ付け

生成時に避けたい要素はタグ付けが必要です：

- `blurry background` - 背景ぼけ
- `motion blur` - モーションブラー
- `low quality` - 低画質部分がある場合
- `cropped` - 画像が切り取られている場合
- `watermark` - 透かしがある場合

---

## タグの粒度と正規化

### LoRAの目的別タグ粒度

| LoRAタイプ | タグの粒度 | 例 |
|-----------|----------|---|
| キャラクター | 詳細（顔パーツ、特徴的な装飾など） | `red eyes`, `scar on cheek`, `silver earring` |
| スタイル | 抽象的（画風、雰囲気） | `impressionist style`, `flat color`, `detailed shading` |
| コンセプト | 中程度（特徴的な要素） | `cyberpunk aesthetic`, `steampunk machinery` |

### 重複タグの扱い

自動生成されやすい重複タグや類似タグは整理が必要です：

| 整理前 | 整理後 |
|-------|-------|
| `1girl`, `solo`, `female` | `1girl, solo` |
| `long hair`, `very long hair` | より具体的な方を選択 |
| `smile`, `happy`, `smiling` | `smile` に統一 |

### タグの正規化

一貫性を保つため、以下のルールで正規化します：

- **大文字小文字**: 全て小文字で統一
- **スペース**: アンダースコアまたはスペースで統一
- **句読点**: 不要な句読点は除去
- **順序**: トリガーワード → 被写体 → 属性 → 背景 → 品質

---

## データセット作成のベストプラクティス

### 画像の品質

| 項目 | 推奨 |
|-----|-----|
| 解像度 | 1024x1024以上 |
| ピント | 被写体にピントが合っていること |
| ウォーターマーク | なし |
| フィルター | 過度な加工なし |
| 形式 | PNG推奨（JPEGでも可） |

### バリエーション

多様な画像を用意することで柔軟なLoRAが作成できます：

| 推奨 | 避けるべき |
|-----|----------|
| 様々なアングル | 同じアングルのみ |
| 様々な服装 | すべて同じ服装 |
| 様々な背景 | すべて同じ背景 |
| 様々な表情 | すべて同じ表情 |
| 様々な照明 | すべて同じ照明 |

### アングルのバランス

以下のバランスで画像を用意（20枚の場合の目安）：

| アングル | 枚数 | 用途 |
|---------|-----|-----|
| クローズアップ（顔） | 5-6枚 | 顔の特徴学習 |
| バストアップ（上半身） | 8-10枚 | メインの学習 |
| 全身ショット | 4-6枚 | 体型・プロポーション学習 |

---

## WD Taggerの活用

### 自動タグ生成の流れ

```
1. make tagger     → 自動タグ生成
2. make edit       → Tag Editorで確認・修正
3. トリガーワード追加
4. 不要タグ削除
5. 欠落タグ追加
```

### WD Taggerのオプション

```bash
# 閾値を調整（デフォルト: 0.35）
--threshold 0.5    # より確実なタグのみ生成
--threshold 0.25   # より多くのタグを生成

# 既存タグを上書き
--overwrite

# 再帰的に処理
--recursive
```

### 自動タグ生成の限界

WD Taggerは強力ですが完璧ではありません：

| 限界 | 対処法 |
|-----|-------|
| 誤認識 | 目視確認で修正 |
| 過剰なタグ | 不要なタグを削除 |
| 不足するタグ | 手動で追加 |
| トリガーワードなし | 手動で全画像に追加 |

### Tag Editorでの編集ポイント

1. **一括置換機能**: 同じ修正を全画像に適用
2. **フィルタリング**: 特定のタグを持つ画像を絞り込み
3. **タグの追加/削除**: 選択した画像にまとめて適用
4. **プレビュー**: 画像を見ながらタグを確認

---

## よくある問題と解決策

### 問題: 生成時に特定の要素が消せない

**原因**: その要素がタグ付けされていない

**解決**: すべての画像でその要素をタグ付けする

**例**: 帽子が消せない → 全画像に `hat` タグを追加

### 問題: 解剖学的な問題（頭が大きい、手がおかしいなど）

**原因**:
- 不均一なクロッピング
- 特定アングルの画像が多すぎる
- 学習画像の解剖学的問題

**解決**:
- クロッピングを統一
- 全身ショットを追加
- 極端なアングルの画像を除去
- 解剖学的に正確な画像を選定

### 問題: スタイルが安定しない

**原因**: データセット内の画質・スタイルのばらつき

**解決**:
- 品質タグを追加（`high quality`, `best quality`）
- 低品質画像を除去または品質タグで区別
- スタイルが一貫した画像のみを使用

### 問題: 特定のポーズがうまく生成されない

**原因**: そのポーズのバリエーションが少ない、またはタグ付けが不十分

**解決**:
- そのポーズの画像を増やす
- `standing`, `sitting`, `arms crossed` など具体的なポーズタグを正確に付与

### 問題: 特定の服装がうまく生成されない

**原因**: 服装のタグ付けが不十分、または服装と他の要素が混同されている

**解決**:
- 服装の詳細をタグ付け（`white shirt`, `long sleeves`, `collar`）
- 異なる服装のバリエーションを追加
- 服装単体の要素をタグで分離

---

## 参考リンク

- [Detailed Stable Diffusion LoRA training guide](https://www.viewcomfy.com/blog/detailed-LoRA-training-guide-for-Stable-Diffusion)
- [How to train LoRA models - Stable Diffusion Art](https://stable-diffusion-art.com/train-lora/)
- [Mastering Stable Diffusion LoRA Training](https://kontextlora.org/blog/mastering-stable-diffusion-lora-training)
- [LoRA Training Best Practices](https://www.finetuners.ai/post/training-lora-on-flux-best-practices-settings)
- [The Ultimate Stable Diffusion LoRA Guide](https://aituts.com/stable-diffusion-lora/)
