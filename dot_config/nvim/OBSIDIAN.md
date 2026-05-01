# Neovim × Obsidian 操作ガイド

プラグイン: `epwalsh/obsidian.nvim`
設定ファイル: `lua/plugins/obsidian.lua`
Vault パス: `/Users/yumac/src/github.com/ok66ym/obsidian`

---

## 読み込みタイミング

obsidian.nvim は Vault 内の Markdown ファイルを開いた時に自動ロードされる。
それ以外のバッファ（CFO-Alpha 等）からでも、以下の方法で使用できる:

- `<Leader>o*` キー（`<Leader>of`, `<Leader>on` 等）を押す → 自動でロード
- `:Obsidian*` コマンドを実行する → 自動でロード

Vault 内のファイルを直接開く方法:
```
:e /Users/yumac/src/github.com/ok66ym/obsidian/020_Inbox/note.md
```
または Telescope からノートを検索:
```
<Leader>of    →  Obsidian: ノート検索（Telescope）
```

---

## テンプレートからノートを作成する

obsidian.nvim でテンプレートを使ってノートを作成する手順:

```
1. <Leader>on でノートを作成（タイトルを入力 → Enter）
   ↓
2. <Leader>ot でテンプレートを選択（000_Setting/templates/ 内の一覧が Telescope で表示）
   ↓
3. テンプレートの内容が現在バッファに挿入される
   ↓
4. :w で保存
```

テンプレートで使える変数:

| 変数 | 展開内容 |
|------|---------|
| `{{date}}` | 今日の日付（YYYY-MM-DD） |
| `{{time}}` | 現在時刻（HH:MM） |
| `{{title}}` | ノートのタイトル |

> Obsidian GUI アプリの Templater プラグインのコマンドは Neovim から直接実行できない。
> `<Leader>oo` で GUI アプリを開き、そちらで Templater コマンドを実行する。

---

## キーバインド一覧

| キー | 動作 | 備考 |
|------|------|------|
| `<Leader>of` | Vault をディレクトリツリーで開く（snacks explorer）。explorer 内で押すと閉じて neo-tree を復元 | ノートが real buffer で開く。リンク追跡有効 |
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

## Vault Explorer のトグル動作

`<Leader>of` はフォーカス位置によって動作が変わる:

| フォーカス位置 | `<Leader>of` の動作 |
|------|------|
| snacks explorer 内 | explorer を閉じて neo-tree を復元 |
| エディタ（ファイル編集中） | Vault explorer を開く（他に picker が開いていれば先に閉じる） |
| neo-tree 内（`O` キー） | neo-tree を閉じて Vault explorer を開く |

`<Leader>e` との使い分け:

| 操作 | 動作 |
|------|------|
| `<Leader>of`（エディタから） | Vault explorer を開く |
| `<Leader>e`（エディタから、explorer が開いている） | explorer にフォーカスを戻す |
| `<Leader>e`（snacks explorer 内） | エディタに戻る（explorer は開いたまま） |
| `<Leader>of`（snacks explorer 内） | explorer を閉じて neo-tree を復元 |
| `q`（snacks explorer 内） | explorer を閉じる（neo-tree は自動復元されない） |

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
:e /Users/yumac/src/github.com/ok66ym/obsidian/020_Inbox/note.md
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
