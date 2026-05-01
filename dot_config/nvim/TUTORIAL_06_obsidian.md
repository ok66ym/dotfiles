# チュートリアル 6: Obsidian ノート管理

obsidian.nvim を使って Vault の作成・検索・テンプレート・リンクを操作する。

`<Leader>` = `Space`  |  インデックス: `<Leader>?r`  |  前: `<Leader>?5`

---

## 基本情報

| 設定 | 値 |
|------|----|
| Vault パス | `/Users/yumac/src/github.com/ok66ym/obsidian` |
| 新規ノート保存先 | `020_Inbox/` |
| テンプレート格納先 | `000_Templates/` |
| 画像・添付ファイル | `000_Assets/` |
| 日次ノート | `020_Inbox/YYYY-MM-DD.md` |

プラグインのロードタイミング:
- Vault 内の .md ファイルを開いた時に自動ロード
- どのリポジトリからでも `<Leader>o*` キーまたは `:Obsidian*` コマンドを実行するとロード

---

## Step 1: Obsidian Vault を開く

### 別リポジトリ（CFO-Alpha 等）から Vault を開く

Vault に移動しなくても、以下のキーやコマンドで直接 Vault を操作できる:

```
<Leader>of  → Vault 内のノートを名前で検索して開く
<Leader>og  → Vault 内を全文検索
<Leader>od  → 今日の日次ノートを開く
```

上記を押すと obsidian.nvim が自動でロードされ、Vault 内を検索できる。

### Vault ディレクトリに直接移動する

```sh
cd ~/src/github.com/ok66ym/obsidian
nvim .
```

または Neovim 内から:

```
:e /Users/yumac/src/github.com/ok66ym/obsidian/020_Inbox/note.md
```

---

## Step 2: ノートを検索・切り替える

| キー | コマンド | 動作 |
|------|---------|------|
| `<Leader>of` | snacks explorer | Vault をディレクトリツリーで開く（もう一度押すと閉じて neo-tree を復元） |
| `<Leader>og` | `:ObsidianSearch` | Vault 内の全文検索（Telescope） |
| `<Leader>os` | `:ObsidianTags` | タグで検索 |
| `<Leader>ob` | `:ObsidianBacklinks` | 現在ノートへのバックリンク一覧 |

### `<Leader>of` — Vault をディレクトリツリーで開く

`<Leader>of` は **snacks explorer** を Obsidian Vault ルートで開く。

- 左サイドバーにディレクトリ構造が表示される
- ファイルを選択すると右のエディタに real buffer として開かれる
- obsidian.nvim のリンク追跡（`<Leader>ol`）やタグ検索が使える
- ノートを閉じると Explorer にフォーカスが戻る
- セッションには保存されない（Vault パスを除外済み）
- `<Leader>e` でエクスプローラー ↔ エディタをトグル
- **エディタにいる状態**で `<Leader>of` を押すと Vault Explorer が開く
- **Explorer 内にいる状態**で `<Leader>of` を押すと Explorer が閉じて neo-tree が復元される
- neo-tree にいる場合は `O` キーで Vault Explorer を開ける

Explorer 内の操作:

| キー | 動作 |
|------|------|
| `j / k` | ファイル・ディレクトリを移動 |
| `Enter` または `l` | ファイルを開く / ディレクトリを展開 |
| `h` | ディレクトリを閉じる |
| `<Leader>e` | Explorer ↔ エディタのフォーカス切り替え |
| `<Leader>of` | Explorer を閉じて neo-tree を復元 |

> CFO-Alpha などのプロジェクトで作業中に `<Leader>of` を押すと、
> neo-tree が一時的に閉じて Vault Explorer が表示される。
> Vault 探索が終わったら `<Leader>of` を再度押すと Explorer が閉じ、neo-tree が自動で復元される。
> または `<Leader>e` でエディタに戻りながら Explorer を残しておくことも可能。

### 練習 2-A

1. CFO-Alpha 編集中に `<Leader>of` を押す
2. 左サイドバーに Obsidian Vault のディレクトリ構造が表示されることを確認
3. `j/k` でディレクトリを移動、`Enter` でノートを開く
4. ノート内で `<Leader>ol` でリンク追跡ができることを確認
5. `<Leader>bd` でノートを閉じる → Explorer にフォーカスが戻る
6. `<Leader>of` で Explorer を閉じて neo-tree を復元 → CFO-Alpha の作業に戻る

---

## Step 3: 新規ノートを作成する

### 方法 A: タイトルを指定して作成

```
<Leader>on  → タイトルを入力するプロンプトが出る
```

タイトルを入力して `Enter` → `020_Inbox/` に新規ノートが作成される。

コマンドでも可能:

```
:ObsidianNew          → タイトル入力プロンプト
:ObsidianNew メモ名   → 直接タイトルを指定
```

### 方法 B: テンプレートからノートを作成する

obsidian.nvim にはテンプレートからノートを直接作成するコマンドはないが、
以下の2ステップで同等の操作ができる:

```
1. <Leader>on でノートを作成（タイトルを入力）
   ↓
2. <Leader>ot でテンプレートを選択して挿入
```

`<Leader>ot`（`:ObsidianTemplate`）を実行すると、
`000_Setting/templates/` 内のテンプレート一覧が Telescope で表示される。
選択するとテンプレートの内容が現在バッファに挿入される。

> Obsidian GUI アプリの Templater プラグインによるコマンドは Neovim から直接呼び出せない。
> `<Leader>oo` でGUIアプリを開き、そちらで Templater コマンドを実行することができる。

### テンプレートで使える変数

| 変数 | 展開内容 |
|------|---------|
| `{{date}}` | 今日の日付（YYYY-MM-DD） |
| `{{time}}` | 現在時刻（HH:MM） |
| `{{title}}` | ノートのタイトル |

### 練習 3-A

1. `<Leader>on` でノートを作成（タイトル: 「テスト」）
2. `<Leader>ot` でテンプレートを選択して挿入
3. `{{date}}` などの変数が展開されることを確認
4. `:w` で保存

---

## Step 4: 日次ノートを使う

```
<Leader>od  → 今日の日次ノートを開く（なければ作成）
```

日次ノートは `020_Inbox/YYYY-MM-DD.md` として自動作成される。

| コマンド | 動作 |
|---------|------|
| `:ObsidianToday` | 今日の日次ノートを開く |
| `:ObsidianYesterday` | 昨日の日次ノートを開く |
| `:ObsidianTomorrow` | 明日の日次ノートを開く |

---

## Step 5: Wiki リンクを操作する

obsidian.nvim は `[[ノート名]]` 形式の wiki リンクをサポートする。

### リンクを入力する（Insert モードで）

Insert モードで `[[` を入力すると、Vault 内のノート名が補完候補に出る。
候補を選択すると `[[ノート名]]` 形式で挿入される。

### リンクを開く

```
<Leader>ol  → カーソル下のリンクを開く
```

または `Enter` キーでもリンクを追跡できる。

### リンクを作成する

| 操作 | 動作 |
|------|------|
| Visual で選択後 `:ObsidianLink` | 選択テキストを既存ノートにリンク |
| Visual で選択後 `:ObsidianLinkNew` | 選択テキストから新規ノートを作成してリンク |
| Visual で選択後 `:ObsidianExtractNote` | 選択範囲を新規ノートに切り出し |

---

## Step 6: タグ・検索

### タグで検索

```
<Leader>os  → タグ一覧から選択して絞り込み（Telescope）
```

ノート内では `#タグ名` 形式でタグを付ける。

### 全文検索

```
<Leader>og  → キーワードで Vault 全体を検索（Telescope）
```

---

## Step 7: Obsidian GUI アプリとの連携

```
<Leader>oo  → 現在のノートを Obsidian GUI アプリで開く
```

Neovim と Obsidian GUI は同じファイルを参照するため、
どちらで編集しても自動的に反映される。

> 両方を同時に開いている場合は、片方で保存してからもう片方を更新する。
> 競合を防ぐため、どちらか一方を使うことを推奨する。

---

## ワークスペースの切り替え

複数の Vault を登録している場合:

```
<Leader>ow  → ワークスペース一覧から選択
```

コマンドでも可能:

```
:ObsidianWorkspace             → 一覧表示
:ObsidianWorkspace ワーク名    → 直接切り替え
```

---

## チェックボックス

| 記法 | 表示 | 意味 |
|-----|-----|------|
| `- [ ]` | ☐ | 未完了 |
| `- [x]` | ✔ | 完了 |
| `- [>]` | ▶ | 繰り越し |
| `- [~]` | ≈ | 削除/キャンセル |

---

## キーバインド早見表

| キー | 動作 | 備考 |
|------|------|------|
| `<Leader>of` | ノートをフロートで閲覧 | 別リポジトリから推奨。セッション汚染なし |
| `<Leader>og` | Vault 全体を全文検索 | |
| `<Leader>ob` | バックリンク一覧 | Vault 内から使用 |
| `<Leader>od` | 今日の日次ノートを開く | |
| `<Leader>ol` | カーソル下のリンクを開く | |
| `<Leader>on` | 新規ノートを作成 | |
| `<Leader>oo` | Obsidian GUI アプリで開く | |
| `<Leader>op` | クリップボードの画像を貼り付け | |
| `<Leader>os` | タグで検索 | |
| `<Leader>ot` | テンプレートを挿入 | |
| `<Leader>ow` | ワークスペースを切替 | |

---

## トラブルシューティング

### キーバインドが効かない

obsidian.nvim は Vault 外のバッファで使う場合、
`<Leader>o*` キーを押した時に自動でロードされる。
それでも動かない場合:

```
:checkhealth obsidian
```

で状態を確認する。

### リンク補完が出ない

Insert モードで `[[` を2文字入力した後、`Ctrl+Space` で補完を強制表示する。

### 画像が貼り付けられない

```sh
brew install pngpaste
```

を実行してから再試行する。

---

お疲れ様でした。`<Leader>?b` でより詳細な OBSIDIAN.md を参照できる。
