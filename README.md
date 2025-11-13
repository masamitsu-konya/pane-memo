# pane-memo

> Never forget what you're doing in each tmux pane

**pane-memo** is a tmux plugin that automatically displays information about the currently selected pane in pane 0. No more scrolling through pane history to remember what you were doing!

[日本語版はこちら](#日本語)

## Features

- **Automatic updates**: Information updates instantly when you switch panes
- **Rich information display**:
  - Current working directory
  - Running command/process
- **Beautiful formatting**: Color-coded box display with clear sections
- **Highly configurable**: Customize target pane and display options
- **Zero dependencies**: Pure bash script, works on any Unix-like system
- **TPM compatible**: Easy installation with Tmux Plugin Manager

## Preview

```
┌──────────────────────────────────────────────────────────┐
│ Pane 2 Information                                       │
│──────────────────────────────────────────────────────────│
│ Directory: /Users/username/projects/my-app               │
│ Running:   vim                                           │
└──────────────────────────────────────────────────────────┘
```

## Installation

### Quick Install (Recommended)

Run the installation script:

```bash
curl -fsSL https://raw.githubusercontent.com/masamitsu-konya/pane-memo/main/install.sh | bash
```

Or download and run manually:

```bash
curl -fsSL https://raw.githubusercontent.com/masamitsu-konya/pane-memo/main/install.sh -o install.sh
bash install.sh
```

The script will automatically:
- Create `~/.tmux/plugins` directory if needed
- Clone the repository
- Add configuration to `.tmux.conf`

After installation:
1. Reload tmux: `tmux source-file ~/.tmux.conf`
2. Start watch script in pane 0: `bash ~/.tmux/plugins/pane-memo/scripts/watch_display.sh`

### Using TPM

1. Add plugin to your `.tmux.conf`:

```bash
set -g @plugin 'masamitsu-konya/pane-memo'
```

2. Press `prefix + I` to install the plugin

3. Start watch script in pane 0: `bash ~/.tmux/plugins/pane-memo/scripts/watch_display.sh`

### Manual Installation

1. Clone this repository (creates directory automatically):

```bash
mkdir -p ~/.tmux/plugins
git clone https://github.com/masamitsu-konya/pane-memo.git ~/.tmux/plugins/pane-memo
```

2. Add to your `.tmux.conf`:

```bash
run-shell ~/.tmux/plugins/pane-memo/pane-memo.tmux
```

3. Reload tmux configuration:

```bash
tmux source-file ~/.tmux.conf
```

4. Start the watch script in pane 0:

```bash
# In tmux, switch to pane 0 and run:
bash ~/.tmux/plugins/pane-memo/scripts/watch_display.sh
```

## Configuration

Add these options to your `.tmux.conf`:

```bash
# Change target pane (default: 0)
set -g @pane-memo-target-pane "0"

# Enable/disable plugin (default: on)
set -g @pane-memo-enabled "on"
```

## Usage

1. **Create pane 0**: Make sure you have at least one pane numbered 0 (usually the first pane)
2. **Switch panes**: Use your normal pane switching commands (`prefix + arrow keys`, etc.)
3. **View information**: Pane 0 automatically updates with current pane information

### Tips

- Keep pane 0 visible in a small split for constant reference
- Use tmux layouts like `main-horizontal` or `main-vertical` to keep pane 0 accessible
- If you don't need the display temporarily, switch to pane 0 itself (it won't update when focused)

## Troubleshooting

### Pane 0 doesn't update

1. Check that focus-events are enabled: `tmux show-options -g focus-events`
2. Verify the plugin is loaded: `tmux show-hooks -g | grep pane-focus-in`
3. Ensure pane 0 exists: `tmux list-panes`

### Display is corrupted or overlapping

Make sure the watch script is running in pane 0. The watch script should be the only thing running in pane 0 for best results.

## How It Works

1. **Watch script**: A monitoring script runs continuously in pane 0
2. **Hook registration**: The plugin registers tmux hooks (`pane-focus-in`, `window-pane-changed`)
3. **Event detection**: When you switch panes, tmux triggers the hooks
4. **Information gathering**: Scripts collect current directory and running command
5. **File update**: Information is written to `/tmp/pane-memo-display`
6. **Display update**: Watch script detects the file change and updates the display

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development

```bash
# Clone the repository
git clone https://github.com/masamitsu-konya/pane-memo.git
cd pane-memo

# Make your changes
# ...

# Test manually
tmux source-file pane-memo.tmux
```

## License

MIT License - see [LICENSE](LICENSE) file for details

## Author

Created by [Masamitsu Konya](https://github.com/masamitsu-konya)

---

## 日本語

> tmuxの各ペインで何をしていたか、もう忘れない

**pane-memo**は、tmuxでペインを切り替えるたびに、現在選択中のペインの情報をペイン0に自動表示するプラグインです。もうペインの履歴をスクロールして何をしていたか思い出す必要はありません！

## 機能

- **自動更新**: ペインを切り替えると瞬時に情報が更新されます
- **充実した情報表示**:
  - カレントディレクトリ
  - 実行中のコマンド/プロセス
- **美しいフォーマット**: 色分けされたボックス表示で見やすい
- **高度な設定**: ターゲットペインや表示オプションをカスタマイズ可能
- **依存関係ゼロ**: 純粋なbashスクリプト、あらゆるUnix系システムで動作
- **TPM対応**: Tmux Plugin Managerで簡単インストール

## インストール

### クイックインストール（推奨）

インストールスクリプトを実行:

```bash
curl -fsSL https://raw.githubusercontent.com/masamitsu-konya/pane-memo/main/install.sh | bash
```

または手動でダウンロードして実行:

```bash
curl -fsSL https://raw.githubusercontent.com/masamitsu-konya/pane-memo/main/install.sh -o install.sh
bash install.sh
```

スクリプトが自動的に以下を実行します:
- `~/.tmux/plugins` ディレクトリの作成（必要な場合）
- リポジトリのクローン
- `.tmux.conf` への設定追加

インストール後:
1. tmuxを再読み込み: `tmux source-file ~/.tmux.conf`
2. ペイン0で監視スクリプトを起動: `bash ~/.tmux/plugins/pane-memo/scripts/watch_display.sh`

### TPMを使用する場合

1. `.tmux.conf`にプラグインを追加:

```bash
set -g @plugin 'masamitsu-konya/pane-memo'
```

2. `prefix + I`でプラグインをインストール

3. ペイン0で監視スクリプトを起動: `bash ~/.tmux/plugins/pane-memo/scripts/watch_display.sh`

### 手動インストール

1. リポジトリをクローン（ディレクトリは自動作成されます）:

```bash
mkdir -p ~/.tmux/plugins
git clone https://github.com/masamitsu-konya/pane-memo.git ~/.tmux/plugins/pane-memo
```

2. `.tmux.conf`に追加:

```bash
run-shell ~/.tmux/plugins/pane-memo/pane-memo.tmux
```

3. tmux設定を再読み込み:

```bash
tmux source-file ~/.tmux.conf
```

4. ペイン0で監視スクリプトを起動:

```bash
# tmux内でペイン0に切り替えて実行:
bash ~/.tmux/plugins/pane-memo/scripts/watch_display.sh
```

## 設定

`.tmux.conf`に以下のオプションを追加できます:

```bash
# ターゲットペインを変更（デフォルト: 0）
set -g @pane-memo-target-pane "0"

# プラグインの有効/無効（デフォルト: on）
set -g @pane-memo-enabled "on"
```

## 使い方

1. **ペイン0を作成**: 番号0のペインがあることを確認（通常は最初のペイン）
2. **ペインを切り替え**: 通常のペイン切り替えコマンドを使用（`prefix + 矢印キー`など）
3. **情報を確認**: ペイン0が自動的に現在のペイン情報で更新されます

### ヒント

- ペイン0を小さい分割で常に表示しておくと便利です
- `main-horizontal`や`main-vertical`などのtmuxレイアウトを使ってペイン0をアクセスしやすくしましょう
- 一時的に表示が不要な場合は、ペイン0自体に切り替えると更新されません

## ライセンス

MIT License - 詳細は[LICENSE](LICENSE)ファイルを参照してください
