# chezmoi 操作ガイド

Neovim から chezmoi で管理している dotfiles の確認・追加・適用を行う。

`<Leader>` = `Space`

---

## chezmoi とは

chezmoi はホームディレクトリの dotfiles を Git で管理するツール。

| 用語 | 意味 |
|------|------|
| ソースディレクトリ | `~/.local/share/chezmoi/` — ここに dotfiles の「正解」が入っている |
| 目的ディレクトリ | `~/` — 実際に使われる設定ファイルが置かれる場所 |
| `add` | 目的ファイルをソースに取り込む（destination → source） |
| `apply` | ソースの内容を目的ファイルに反映する（source → destination） |

---

## キーバインド一覧

| キー | 動作 |
|------|------|
| `<Leader>czf` | 管理ファイル一覧を Telescope で開く |
| `<Leader>czd` | 全体の diff をフロートウィンドウで表示 |
| `<Leader>czD` | 現在ファイルの diff をフロートウィンドウで表示 |
| `<Leader>cza` | 現在ファイルを chezmoi に add（目的 → ソース） |
| `<Leader>czp` | chezmoi apply（ソース → 目的） |
| `<Leader>czs` | chezmoi status（変更サマリー） |
| `<Leader>czo` | ソースディレクトリをトグル（explorer 内で押すと閉じて neo-tree を復元） |

> which-key で `<Leader>cz` まで押すと操作一覧が表示される。

---

## よくある操作フロー

### 実際の設定ファイルを変更してソースに同期する

```
1. ~/.zshrc などを直接編集・保存
2. <Leader>czD  で変更内容を確認
3. <Leader>cza  で chezmoi にその変更を取り込む（add）
4. ソースディレクトリで git commit して管理
```

### ソースディレクトリを編集して各ファイルに反映する

```
1. <Leader>czo  でソースディレクトリを開く
2. dot_zshrc などのソースファイルを直接編集・保存
3. <Leader>czd  で差分を確認
4. <Leader>czp  で apply（ソースの内容を ~/.zshrc 等に反映）
```

### 差分を確認してから apply する

```
1. <Leader>czd  で全体の差分を確認（diff ビューア）
   または
   <Leader>czs  で status（どのファイルが変更されているか）を確認
2. <Leader>czp  で apply
```

---

## フロートウィンドウ（diff / status）内の操作

diff / status の結果はフロートウィンドウで表示される。

| キー | 動作 |
|------|------|
| `j / k` | 上下スクロール |
| `/{検索語}` | 差分内を検索 |
| `n / N` | 次/前の検索一致へ移動 |
| `q` | フロートを閉じる |

---

## Telescope ピッカー（`<Leader>czf`）内の操作

| キー | 動作 |
|------|------|
| `Ctrl+j/k` | 候補を上下移動 |
| `Enter` | ファイルを開く（ソースファイル） |
| `Ctrl+v` | 垂直分割で開く |
| `Ctrl+x` | 水平分割で開く |
| `Esc` | 閉じる |

ソースファイルを開いて保存すると、`chezmoi apply` で対応する設定ファイルに反映できる。

---

## chezmoi status の見方

```
M  .zshrc          # M = Modified（ソースが新しい → apply すると目的に反映）
A  .config/foo     # A = Added（ソースにあるが目的にない → apply で作成）
D  .config/bar     # D = Deleted（ソースで削除済み → apply で目的からも削除）
```

---

## snacks explorer（ソースディレクトリ）のトグル動作

`<Leader>czo` はフォーカス位置によって動作が変わる:

| フォーカス位置 | `<Leader>czo` の動作 |
|------|------|
| snacks explorer 内 | explorer を閉じて neo-tree を復元 |
| エディタ（ファイル編集中） | explorer を開く（他に picker が開いていれば先に閉じる） |
| neo-tree 内（`Z` キー） | neo-tree を閉じて explorer を開く |

`<Leader>e` との使い分け:

| 操作 | 動作 |
|------|------|
| `<Leader>czo`（エディタから） | chezmoi explorer を開く |
| `<Leader>e`（エディタから、explorer が開いている） | explorer にフォーカスを戻す |
| `<Leader>e`（snacks explorer 内） | エディタに戻る（explorer は開いたまま） |
| `<Leader>czo`（snacks explorer 内） | explorer を閉じて neo-tree を復元 |
| `q`（snacks explorer 内） | explorer を閉じる（neo-tree は自動復元されない） |

---

## ソースディレクトリの構造

chezmoi はファイル名のプレフィックスで特殊な扱いを識別する。

| プレフィックス | 意味 |
|------------|------|
| `dot_` | 目的ファイルでは `.`（ドット）に変換される |
| `private_` | 目的ファイルのパーミッションを 600 に設定 |
| `executable_` | 目的ファイルに実行権限を付与 |
| `run_once_` | 初回のみ実行されるスクリプト |

例: `dot_zshrc` → `~/.zshrc`、`dot_config/nvim/` → `~/.config/nvim/`

---

## プラグイン設定

プラグイン: `xvzc/chezmoi.nvim`
設定ファイル: `~/.config/nvim/lua/plugins/chezmoi.lua`

| 設定 | 値 | 意味 |
|------|-----|------|
| `edit.watch` | `false` | ソースファイル保存時に自動 apply しない（手動操作） |
| `notification.on_open` | `true` | chezmoi 管理ファイルを開いた時に通知 |
| `notification.on_apply` | `true` | apply 完了時に通知 |
