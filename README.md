# SD Dataset Tagger Docker

Stable Diffusion LoRA学習用データセット作成のDocker環境

## 含まれるツール

- **WD Tagger** - 画像の自動タグ生成 (GPU対応)
- **Dataset Tag Editor** - タグの手動編集 (GPU対応)

## 必要環境

- Docker & Docker Compose
- NVIDIA GPU + NVIDIA Container Toolkit

### 環境構築

Nvidia GPU環境のセットアップについては、以下のガイドを参照してください：

**[Ubuntu 24.04 Nvidia Setup Guide](https://github.com/masakaya/Ubuntu24.04_nvidia_setup_guide)**

上記ガイドに従って、Docker、Nvidia ドライバー、Nvidia Container Toolkitをインストールしてください。

## ディレクトリ構造

```
.
├── dataset/
│   ├── images/    # 画像を配置
│   └── tags/      # タグファイル出力先
├── models/        # モデルキャッシュ
├── wd-tagger/     # WD Tagger Dockerfile
├── tag-editor/    # Tag Editor Dockerfile
├── compose.yml
└── Makefile
```

## 使用方法

### 1. セットアップ

```bash
make setup
```

### 2. 画像を配置

```bash
cp /path/to/images/* dataset/images/
```

### 3. 自動タグ生成

```bash
make tagger
```

`dataset/images/` 内の画像に対してタグファイル（.txt）が生成されます。

### 4. タグ編集

```bash
make edit
```

ブラウザで http://localhost:7862 にアクセスしてタグを編集。

### 5. 停止

```bash
make down
```

## その他のコマンド

```bash
make build        # イメージをビルド
make logs         # ログを表示
make clean        # コンテナ・ボリュームを削除
make clean-images # Dockerイメージも削除
make help         # ヘルプを表示
```

## ドキュメント

- [タグ付けガイド](docs/captioning-guide.md) - LoRAトレーニング用タグ付けのテクニックと解説

## 参考

- [wd14-tagger-standalone](https://github.com/corkborg/wd14-tagger-standalone)
- [dataset-tag-editor-standalone](https://github.com/toshiaki1729/dataset-tag-editor-standalone)
