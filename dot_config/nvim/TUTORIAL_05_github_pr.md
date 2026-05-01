# チュートリアル 5: GitHub PR レビュー（octo.nvim）

octo.nvim を使って Neovim 内から GitHub PR を確認・コメント・レビューする。

`<Leader>` = `Space`  |  `<LocalLeader>` = `\`（バックスラッシュ）

インデックス: `<Leader>?r`  |  前: `<Leader>?4`  |  次: `<Leader>?6`

---

## 事前条件

```sh
gh auth status   # ログイン状態を確認
gh auth login    # 未ログインの場合
```

---

## Step 1: PR を開く（グローバルキー）

どのバッファからでも使えるキー:

| キー | 動作 |
|------|------|
| `<Leader>po` | 現在ブランチの PR を開く（最もよく使う） |
| `<Leader>pp` | PR 一覧を Telescope で表示して選択 |
| `<Leader>pf` | PR の変更ファイル一覧 |
| `<Leader>pc` | PR の CI チェック一覧 |
| `<Leader>pr` | PR レビューを開始 |
| `<Leader>il` | Issue 一覧 |
| `<Leader>ic` | Issue 作成 |

---

## Step 2: PR バッファ内の操作

`<Leader>po` で PR を開くと専用バッファが表示される。
このバッファ内では `\`（バックスラッシュ = LocalLeader）プレフィックスのキーが使える。

### PR の確認・ナビゲーション

| キー | 動作 |
|------|------|
| `]c` | 次のコメントへジャンプ |
| `[c` | 前のコメントへジャンプ |
| `gf` | カーソル位置のファイルを開く |
| `Ctrl+r` | PR を再読み込み |
| `Ctrl+b` | ブラウザで PR を開く |
| `Ctrl+y` | PR の URL をクリップボードにコピー |

### コメント操作

| キー | 動作 |
|------|------|
| `\ca` | コメントを追加（`:w` で送信） |
| `\cr` | コメントに返信 |
| `\cd` | コメントを削除 |

### PR 操作

| キー | 動作 |
|------|------|
| `\po` | PR をチェックアウト（ブランチを切り替え） |
| `\pm` | PR をマージ（merge commit） |
| `\psm` | PR を squash マージ |
| `\prm` | PR を rebase マージ |
| `\pf` | 変更ファイル一覧 |
| `\pd` | PR の diff を表示 |
| `\pc` | コミット一覧 |
| `\ic` | PR をクローズ |
| `\io` | PR を再オープン |

### レビュー操作

| キー | 動作 |
|------|------|
| `\vs` | レビューを開始（pending レビューを作成） |
| `\vr` | 保留中のレビューを再開 |
| `\rt` | スレッドを resolve |
| `\rT` | スレッドを unresolve |

### レビュー提出

```
:Octo review submit   → approve / request changes / comment を選択して提出
```

---

## Step 3: 変更ファイルの差分を確認する

PR バッファ内で `\pf` または `<Leader>pf` でファイル一覧が開く。
ファイルを選択すると diff が表示される。

diff ビュー内のキー:

| キー | 動作 |
|------|------|
| `]c` / `[c` | 次/前の変更ハンクへ |
| `\ca` | 選択行にインラインコメントを追加 |
| `gf` | そのファイルをエディタで開く |

---

## Step 4: PR の Checks（CI）を確認する

```
<Leader>pc  → CI チェック一覧
```

各ジョブの pass / fail が一覧表示される。

---

## Step 5: よくある操作フロー

### 自分の PR をセルフレビューする

```
<Leader>po → 現在ブランチの PR を開く
  ↓
<Leader>pf → 変更ファイルを確認
  ↓
\pf → PR バッファからファイル一覧・diff
  ↓
<Leader>pc → CI チェック状態を確認
```

### レビューコメントに返信する

```
<Leader>po → PR を開く
  ↓
]c → コメントへ移動
  ↓
\cr → 返信を追加（:w で送信）
```

### PR をマージする

```
<Leader>po → PR を開く
  ↓
\pm → merge commit でマージ
（または \psm → squash マージ）
```

---

## コマンドリファレンス

| コマンド | 動作 |
|---------|------|
| `:Octo pr list` | PR 一覧 |
| `:Octo pr edit` | 現在ブランチの PR |
| `:Octo pr edit 123` | PR #123 を開く |
| `:Octo pr checks` | CI 状態 |
| `:Octo pr files` | 変更ファイル一覧 |
| `:Octo pr merge` | マージ |
| `:Octo pr merge squash` | squash マージ |
| `:Octo review start` | レビュー開始 |
| `:Octo review submit` | レビュー提出 |
| `:Octo review discard` | レビュー破棄 |
| `:Octo issue list` | Issue 一覧 |
| `:Octo issue create` | Issue 作成 |

---

次: `<Leader>?6` で Obsidian チュートリアルへ
