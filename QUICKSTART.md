# Quick Start Guide - pane-memo

## 5分で始める pane-memo

### 1. インストール

```bash
# リポジトリをクローン
git clone https://github.com/masamitsu-konya/pane-memo.git ~/.tmux/plugins/pane-memo

# 手動でtmux設定に追加
echo "run-shell ~/.tmux/plugins/pane-memo/pane-memo.tmux" >> ~/.tmux.conf
```

### 2. シェル設定を追加

**Bashユーザー:**

```bash
# .bashrcに追加
cat >> ~/.bashrc << 'EOF'

# pane-memo: ペインごとの履歴トラッキング
export HISTFILE=~/.bash_history_${TMUX_PANE}
export PROMPT_COMMAND="history -a"
EOF

# 設定を反映
source ~/.bashrc
```

**Zshユーザー:**

```bash
# .zshrcに追加
cat >> ~/.zshrc << 'EOF'

# pane-memo: ペインごとの履歴トラッキング
export HISTFILE=~/.zsh_history_${TMUX_PANE}
precmd() { history -a }
EOF

# 設定を反映
source ~/.zshrc
```

### 3. tmuxを起動/再読み込み

```bash
# 既にtmuxセッションがある場合
tmux source-file ~/.tmux.conf

# または新しいセッションを開始
tmux
```

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

#### 履歴が表示されない場合

```bash
# 履歴ファイルの場所を確認
echo $HISTFILE

# シェル設定を再読み込み
source ~/.bashrc  # または source ~/.zshrc

# いくつかコマンドを実行してから再度確認
ls
pwd
echo "test"
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
