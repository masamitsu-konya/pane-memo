# pane-memo 開発ガイド

このプロジェクトは tmux プラグインとして世界中のユーザーに配布する OSS です。

## 開発フロー

### 1. ディレクトリ構成

- **開発ディレクトリ**: `~/apps/pane-memo/`
  - ここでコードを編集します
  - Git リポジトリとして管理されています

- **実行ディレクトリ（開発時）**: `.tmux.conf` で開発ディレクトリを直接参照
  - 開発中は `run-shell ~/apps/pane-memo/pane-memo.tmux` と記述
  - 編集したファイルが即座に反映されます

- **実行ディレクトリ（ユーザー）**: `~/.tmux/plugins/pane-memo/`
  - 一般ユーザーは TPM や git clone でここにインストール
  - 開発時はこのディレクトリを使いません

### 2. 編集後のテスト手順

スクリプトファイルを編集した後、以下の手順で動作確認します：

```bash
# 1. tmux 設定を再読み込み
tmux source-file ~/.tmux.conf

# 2. ペイン0で監視スクリプトを起動（初回のみ、または停止した場合）
tmux send-keys -t :.0 C-c C-l
tmux send-keys -t :.0 "bash ~/apps/pane-memo/scripts/watch_display.sh" Enter

# 3. 別のペインに移動して動作確認
# ペイン1や2にフォーカスを移すと、ペイン0に情報が表示される
```

### 3. 注意事項

- **編集場所**: 必ず `~/apps/pane-memo/` 配下のファイルを編集してください
- **テスト**: 編集後は必ず `tmux source-file ~/.tmux.conf` で設定を再読み込み
- **コミット前**: 動作確認が完了してから git commit してください

### 4. ファイル構成

```
~/apps/pane-memo/
├── pane-memo.tmux          # プラグインのエントリーポイント
├── scripts/
│   ├── get_pane_info.sh    # ペイン情報を取得
│   ├── format_output.sh    # 情報を整形して表示用に変換
│   ├── update_display.sh   # フックから呼ばれる更新スクリプト
│   └── watch_display.sh    # ペイン0で常駐する監視スクリプト
├── README.md
└── QUICKSTART.md
```

### 5. リリース手順

1. 開発ディレクトリで編集・テスト
2. 動作確認完了後、git commit & push
3. ユーザーは以下の方法でインストール：

   **推奨: インストールスクリプト**
   ```bash
   curl -fsSL https://raw.githubusercontent.com/masamitsu-konya/pane-memo/main/install.sh | bash
   ```

   **TPM を使用する場合**
   ```bash
   # .tmux.conf に追加:
   set -g @plugin 'masamitsu-konya/pane-memo'
   ```

   **手動インストール**
   ```bash
   mkdir -p ~/.tmux/plugins
   git clone https://github.com/masamitsu-konya/pane-memo.git ~/.tmux/plugins/pane-memo
   ```

### 6. インストールスクリプト (`install.sh`)

- `~/.tmux/plugins` ディレクトリを自動作成
- リポジトリをクローン
- `.tmux.conf` に設定を追加
- 既存のインストールを検出して再インストール確認
- ユーザーフレンドリーなメッセージ表示

## 開発時の .tmux.conf 設定例

```tmux
# 開発中（開発ディレクトリを参照）
run-shell ~/apps/pane-memo/pane-memo.tmux
set -g @pane-memo-target-pane "0"

# リリース後（一般ユーザー向け）
# run-shell ~/.tmux/plugins/pane-memo/pane-memo.tmux
# set -g @pane-memo-target-pane "0"
```
