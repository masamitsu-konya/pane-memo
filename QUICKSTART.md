# Quick Start Guide - pane-memo

## 5分で始める pane-memo

### 1. インストール

**方法A: インストールスクリプトを使用（推奨）**

```bash
curl -fsSL https://raw.githubusercontent.com/masamitsu-konya/pane-memo/main/install.sh | bash
```

**方法B: 手動インストール**

```bash
# プラグインディレクトリを作成（存在しない場合）
mkdir -p ~/.tmux/plugins

# リポジトリをクローン
git clone https://github.com/masamitsu-konya/pane-memo.git ~/.tmux/plugins/pane-memo

# 手動でtmux設定に追加
echo "run-shell ~/.tmux/plugins/pane-memo/pane-memo.tmux" >> ~/.tmux.conf
```

### 2. tmuxを起動/再読み込み

```bash
# 既にtmuxセッションがある場合
tmux source-file ~/.tmux.conf

# または新しいセッションを開始
tmux
```

### 3. ペイン0で監視スクリプトを起動

```bash
# tmux内でペイン0に切り替えて実行
bash ~/.tmux/plugins/pane-memo/scripts/watch_display.sh
```

このスクリプトはペイン0で常駐して、情報を表示し続けます。

### 4. 使ってみる

1. **tmuxで複数のペインを作成:**

```bash
# 横分割
tmux split-window -h

# 縦分割
tmux split-window -v
```

2. **ペイン間を移動してみる:**

```bash
# 矢印キーでペイン切り替え（prefix は通常 Ctrl+b）
prefix + ←  # 左のペインへ
prefix + →  # 右のペインへ
prefix + ↑  # 上のペインへ
prefix + ↓  # 下のペインへ
```

3. **ペイン0に情報が表示されるのを確認！**

各ペインで作業をして、ペインを切り替えるたびにペイン0の表示が更新されることを確認してください。

### トラブルシューティング

#### 表示が更新されない場合

```bash
# フックが設定されているか確認
tmux show-hooks -g | grep pane-focus-in

# focus-eventsが有効か確認
tmux show-options -g focus-events

# プラグインを手動で再読み込み
tmux source-file ~/.tmux/plugins/pane-memo/pane-memo.tmux
```

#### 表示が更新されない場合

```bash
# ペイン0で監視スクリプトが動作しているか確認
# ペイン0に切り替えて、スクリプトが実行中か確認

# 再起動する場合は Ctrl+C で停止してから再実行
bash ~/.tmux/plugins/pane-memo/scripts/watch_display.sh
```

### 推奨レイアウト

ペイン0を常に見えるようにするための推奨レイアウト：

```bash
# メインペインを大きく、ペイン0を上部に小さく表示
tmux select-layout main-horizontal

# または、メインペインを左に、ペイン0を右に表示
tmux select-layout main-vertical
```

### 次のステップ

- [README.md](README.md) で詳細な設定方法を確認
- カスタマイズオプションの設定（ターゲットペインの変更など）
- GitHubでIssueやPull Requestを送って貢献

楽しいtmuxライフを！
