# チュートリアル 4: 環境操作

ドキュメント参照・tmux 連携・Claude Code・worktree を身につける。

`<Leader>` = `Space`  |  インデックス: `<Leader>?r`  |  前: `<Leader>?3`

---

## Step 1: ドキュメントを参照する

### Neovim 内からドキュメントを開く

`<Leader>?` を押すと which-key にドキュメント一覧が表示される。

| キー | ドキュメント |
|------|-------------|
| `<Leader>?r` | チュートリアル インデックス（今見ているもの） |
| `<Leader>?1` | チュートリアル 1: Vim 基本操作 |
| `<Leader>?2` | チュートリアル 2: ファイル操作 |
| `<Leader>?3` | チュートリアル 3: コード操作 |
| `<Leader>?4` | チュートリアル 4: 環境操作（このドキュメント） |
| `<Leader>?5` | チュートリアル 5: GitHub PR（octo.nvim） |
| `<Leader>?6` | チュートリアル 6: Obsidian ノート管理 |
| `<Leader>?u` | Neovim USAGE.md（キーバインド早見表） |
| `<Leader>?p` | Neovim PLUGINS.md（プラグイン説明） |
| `<Leader>?t` | Ghostty + tmux 操作ガイド |
| `<Leader>?w` | worktree 設定リファレンス |

### フロートウィンドウ内での操作

| キー | 動作 |
|------|------|
| `j / k` | スクロール |
| `Ctrl+d / Ctrl+u` | 半ページスクロール |
| `/{検索語}` | ドキュメント内を検索 |
| `n / N` | 次 / 前の検索結果へ移動 |
| `q` | フロートを閉じて元のバッファに戻る |

### neo-tree を開いた状態でドキュメントを開く

neo-tree にフォーカスがある時は `<Leader>` キーが効かない。
`Ctrl+l` でエディタ側へフォーカスを移してから操作する。

```
neo-tree にフォーカスがある
  ↓
Ctrl+l でエディタ側へ移動
  ↓
<Leader>?u などでドキュメントを開く
  ↓
q でフロートを閉じる
  ↓
<Leader>e で neo-tree に戻る
```

### neo-tree とエディタのフォーカス切り替え

| キー | 動作 |
|------|------|
| `<Leader>e` | neo-tree にフォーカス（閉じていれば開く） |
| `Ctrl+l` | neo-tree → エディタへ移動 |
| `q` | neo-tree を閉じる |

### tmux 内（Neovim 外）からドキュメントを開く

```
prefix + ?  → fzf でドキュメントを選択して bat で表示
```

### 練習 1-A

1. `<Leader>?u` でUSAGE.mdをフロートで開く
2. `/ターミナル` で「ターミナル」を検索
3. `n` で次の一致箇所へ移動
4. `q` でフロートを閉じる
5. `<Leader>?t` でtmux操作ガイドを開く → `q` で閉じる

---

## Step 2: tmux との連携

### Neovim と tmux のペイン間を移動する

`Ctrl+h/j/k/l` は Neovim ウィンドウの移動と tmux ペインの移動が統合されている。
Neovim の外側のペイン（Claude Code が動いているペインなど）にも同じキーで移動できる。

```
worktree 作成直後のレイアウト:

Window 1 "terminal"          Window 2 "nvim"
┌──────────┬──────────┐      ┌─────────────────┐
│ pane 1.1 │ pane 1.2 │      │   Neovim        │
│ (shell)  │ (watch)  │      │  （ここにいる）  │
└──────────┴──────────┘      └─────────────────┘
```

### tmux window を切り替える

| キー | 動作 |
|------|------|
| `Cmd+1` | Window 1（terminal）へ |
| `Cmd+2` | Window 2（nvim）へ |
| `Ctrl+Tab` | 次の window へ |
| `Ctrl+Shift+Tab` | 前の window へ |

### Neovim のペインから tmux ペインへ移動する

```
例: Neovim（Window 2）から Claude Code（Window 1 の pane 1.1）に移動する

方法 A: Cmd+1 で Window 1 に切り替え → そのままターミナルで操作
方法 B: 同じ window 内にいる場合は Ctrl+h/j/k/l でペイン移動
```

### 練習 2-A

1. Neovim を開いた状態で `Cmd+1` を押して Window 1 に移動
2. `Cmd+2` で Neovim に戻る
3. `Ctrl+Tab` で window を順番に切り替える

---

## Step 3: Claude Code を開く・操作する

### Claude Code を起動する

Claude Code は Window 1 の pane 1.1（汎用ターミナル）で起動する。

```
Cmd+1  → Window 1 の pane 1.1 に移動
claude → Claude Code を起動
```

### Neovim からプロンプトを送信する（prefix + Ctrl+g）

Neovim を閉じずに、書いたテキストを Claude Code に送信できる。

```
1. Neovim 内で prefix + Ctrl+g を押す（Ctrl+a → Ctrl+g）
2. フロートポップアップで Neovim が開く（空の markdown ファイル）
3. プロンプトを書く
4. :wq で保存 → 自動的に Claude Code に送信される
5. :q! でキャンセル
```

複数行のプロンプトも書ける。各行が Shift+Enter で区切られて送信される。

### Claude Code の状態アイコン（tmux ステータスバー）

tmux のステータスバー（上部）に Claude Code の状態がアイコンで表示される:

| アイコン | 意味 |
|---------|------|
| ⚡ | ツール実行中 |
| ✅ | 応答完了・入力待ち |
| ❓ | permission プロンプト待ち |

### 練習 3-A

1. `Cmd+1` で Window 1 に移動
2. `claude` コマンドで Claude Code を起動
3. `Cmd+2` で Neovim に戻る
4. Neovim で `prefix + Ctrl+g`（Ctrl+a を押してから Ctrl+g）
5. フロートポップアップで「テストプロンプト」と入力
6. `:wq` で送信
7. `Cmd+1` で Window 1 に戻り、送信されたことを確認

---

## Step 4: フロートターミナル

Neovim を閉じずにターミナルコマンドを実行したい場合に使う。

```
<Leader>t  → フロートターミナルをトグル
```

| 状態 | キー | 動作 |
|------|------|------|
| ターミナル内 | `<Leader>t` | 隠す（プロセスは継続） |
| ターミナル内 | `Ctrl+\` → `Ctrl+n` | ノーマルモードへ（コピー等） |
| ノーマルモード | `i` | 入力モードに戻る |
| ターミナル内 | `exit` | シェルを終了してターミナルを閉じる |

> `<Leader>t` で隠してもプロセスは生きている。
> 再度 `<Leader>t` で同じセッションが再表示される。
> 完全に終了したい場合は `exit` を実行する。

### tmux のペイン分割との使い分け

| 方法 | 向いているケース |
|------|----------------|
| `<Leader>t`（フロートターミナル） | 一時的なコマンド実行・すぐ閉じる |
| `Cmd+n`（tmux ペイン分割） | Claude Code や常時表示したいプロセス |

### 練習 4-A

1. `<Leader>t` でフロートターミナルを開く
2. `ls` コマンドを実行
3. `<Leader>t` でフロートを隠す（Neovim の編集画面に戻る）
4. `<Leader>t` で再度開く → 前のセッションが継続していることを確認
5. `exit` でシェルを終了

---

## Step 5: worktree の切り替え

### worktree を作成・切り替えする

これらは tmux 内の操作（Neovim を閉じても操作できる）。

| キー（tmux prefix + ） | 動作 |
|-----------------------|------|
| `o` | ブランチ名を入力して新規 worktree 作成 |
| `w` | ブランチ/worktree を選択して切り替え |
| `p` | PR 番号を入力して worktree 作成 |
| `q` | worktree を選択して削除 |

### worktree 作成直後の構成

worktree を作成すると以下が自動で立ち上がる:

```
Window 1 "terminal":
  pane 1.1 — 汎用ターミナル（Claude Code を起動する場所）
  pane 1.2 — npm run watch（フロントサーバー）

Window 2 "nvim":
  Neovim がワークツリールートで起動（自動フォーカス）
```

### 練習 5-A

1. `Cmd+1` で Window 1 に移動
2. `prefix + w`（Ctrl+a → w）で worktree 一覧を開く
3. fzf で別のブランチを選択して切り替えを確認
4. `Cmd+2` で Window 2（Neovim）を確認

---

## 総合練習: 実際の開発フロー

以下の流れを一通り試してみる:

```
1. worktree を作成（prefix + o でブランチ名入力）
   ↓
2. Window 2 の Neovim で自動起動を確認
   ↓
3. <Leader>ff でファイルを開いて実装
   ↓
4. gd で定義にジャンプ → Ctrl+o で戻る
   ↓
5. :w で保存 → ガターの変更サインを確認
   ↓
6. <Leader>gp でハンクのプレビュー（変更前後を確認）
   ↓
7. <Leader>gv で diffview を開いてステージング
      ファイルパネルで s/S → ステージ / q で閉じる
   ↓
8. prefix + Ctrl+g で Claude Code にプロンプトを送信
   ↓
9. <Leader>gg で lazygit を開いてコミット・Push
   ↓
10. <Leader>?u で USAGE.md を開いて操作を確認
   ↓
11. q でフロートを閉じて作業に戻る
```

---

お疲れ様でした。チュートリアルはこれで終わり。
USAGE.md（`<Leader>?u`）に全キーバインドの早見表がある。
