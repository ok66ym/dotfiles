# Neovim × Obsidian 操作ガイド

プラグイン: `epwalsh/obsidian.nvim`
設定ファイル: `lua/plugins/obsidian.lua`
Vault パス: `/Users/yuma-oka/src/github.com/ok66ym/obsidian`

---

## 読み込みタイミング

obsidian.nvim は **Vault 内の Markdown ファイルを開いた時のみ** 読み込まれる。
Neovim 全体に影響しないため、CFO-Alpha の作業中に `.md` ファイルを開いても干渉しない。

Vault 内のファイルを開く方法:
```
:e /Users/yuma-oka/src/github.com/ok66ym/obsidian/020_Inbox/note.md
```
または Telescope から vault 内ファイルを探す:
```
<Leader>of    →  Obsidian: ノート検索（Telescope）
```

---

## キーバインド一覧

| キー | コマンド | 動作 |
|------|---------|------|
| `<Leader>of` | `:ObsidianQuickSwitch` | ノートを名前で検索・切替（Telescope） |
| `<Leader>og` | `:ObsidianSearch` | Vault 内の全文検索（Telescope） |
| `<Leader>on` | `:ObsidianNew` | 新規ノートを作成 |
| `<Leader>od` | `:ObsidianToday` | 今日の日次ノートを開く |
| `<Leader>ol` | `:ObsidianFollowLink` | カーソル下のリンクを開く |
| `<Leader>ob` | `:ObsidianBacklinks` | 現在ノートへのバックリンク一覧 |
| `<Leader>os` | `:ObsidianTags` | タグで検索 |
| `<Leader>ot` | `:ObsidianTemplate` | テンプレートを挿入 |
| `<Leader>oo` | `:ObsidianOpen` | Obsidian GUI アプリで開く |
| `<Leader>op` | `:ObsidianPasteImg` | クリップボードの画像を貼り付け |
| `<Leader>ow` | `:ObsidianWorkspace` | ワークスペースを切替 |

---

## コマンド一覧（直接実行）

| コマンド | 動作 |
|---------|------|
| `:ObsidianNew [title]` | 新規ノートを作成（タイトル指定可） |
| `:ObsidianToday` | 今日の日次ノートを開く |
| `:ObsidianYesterday` | 昨日の日次ノートを開く |
| `:ObsidianTomorrow` | 明日の日次ノートを開く |
| `:ObsidianQuickSwitch` | ノートをファジー検索で切替 |
| `:ObsidianSearch [query]` | 全文検索 |
| `:ObsidianFollowLink` | カーソル下のリンクを開く |
| `:ObsidianBacklinks` | バックリンク一覧をポップアップ表示 |
| `:ObsidianTags [tag]` | タグ検索 |
| `:ObsidianTemplate [name]` | テンプレートを挿入 |
| `:ObsidianOpen` | Obsidian GUI アプリで現在ノートを開く |
| `:ObsidianWorkspace [name]` | ワークスペースを切替 |
| `:ObsidianRename [new_name]` | 現在ノートをリネーム（リンクも更新） |
| `:ObsidianExtractNote` | 選択範囲を新規ノートに抽出 |
| `:ObsidianLinkNew` | 選択テキストから新規ノートを作成してリンク |
| `:ObsidianLink [query]` | 選択テキストを既存ノートにリンク |
| `:ObsidianPasteImg [name]` | クリップボードの画像を保存して埋め込み |

---

## Wiki リンクの操作

obsidian.nvim は `[[ノート名]]` 形式の wiki リンクをサポートする。

| 操作 | 方法 |
|------|------|
| リンクを開く | カーソルを `[[...]]` に置いて `<Leader>ol` |
| 新規リンク作成 | Insert モードで `[[` を入力すると補完が出る |
| 既存ノートへリンク | Visual で選択後 `:ObsidianLink` |
| 選択範囲を新規ノートに | Visual で選択後 `:ObsidianLinkNew` |

### 補完（nvim-cmp と連携）

Insert モードで `[[` を入力すると、Vault 内のノート名が補完候補に表示される。

---

## チェックボックス

| 記法 | 表示 | 意味 |
|-----|-----|------|
| `- [ ]` | ☐ | 未完了 |
| `- [x]` | ✔ | 完了 |
| `- [>]` | ▶ | 繰り越し |
| `- [~]` | ≈ | 削除/キャンセル |

---

## ディレクトリ設定

| 用途 | パス |
|------|------|
| 新規ノートのデフォルト保存先 | `020_Inbox/` |
| 日次ノート | `020_Inbox/YYYY-MM-DD.md` |
| テンプレート | `000_Templates/` |
| 添付ファイル（画像等） | `000_Assets/` |

---

## Obsidian GUI との共存

- `<Leader>oo` で GUI の Obsidian アプリを起動して現在ノートを開ける
- Neovim で編集したファイルは自動的に Obsidian GUI に反映される（ファイル監視）
- Obsidian GUI のキーバインドやプラグイン設定はそのまま使える
- 両方を同時に開いて編集する場合は、**片方で保存してからもう片方を確認**する（競合を避けるため）

---

## トラブルシューティング

### obsidian.nvim が読み込まれない

Vault 内の Markdown ファイルを直接開く必要がある:
```
:e /Users/yuma-oka/src/github.com/ok66ym/obsidian/020_Inbox/note.md
```

### リンクが機能しない

`:checkhealth obsidian` で状態を確認する:
```
:checkhealth obsidian
```

### 補完が出ない

Insert モードで `[[` を2文字入力した後、`Ctrl+Space` で補完を強制表示する。

### 画像の貼り付けができない

`pbpaste` でクリップボードの画像が取得できるか確認する。
macOS では `pngpaste` のインストールが必要な場合がある:
```sh
brew install pngpaste
```
