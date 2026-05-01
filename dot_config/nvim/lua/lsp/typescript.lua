-- TypeScript / JavaScript 言語サーバー
return function()
  local lsp = require("lsp")

  vim.lsp.config("ts_ls", {
    on_attach = function(client, bufnr)
      -- 共通キーバインド（K, gr, gi, Leader+ca 等）を先に登録
      lsp.on_attach(client, bufnr)

      -- TypeScript 専用: gd を実装ファイルへの直接ジャンプに上書き
      --
      -- 通常の textDocument/definition は import 文や .d.ts 型定義ファイルを返す。
      -- _typescript.goToSourceDefinition は TypeScript サーバー固有のコマンドで、
      -- import・.d.ts をスキップして実装ソースファイルへ直接ジャンプする。
      -- vibes / standard-ui などの内部ライブラリでも実装元へ飛べる。
      vim.keymap.set("n", "gd", function()
        local win    = vim.api.nvim_get_current_win()
        local params = vim.lsp.util.make_position_params(win, client.offset_encoding)

        client:exec_cmd({
          command   = "_typescript.goToSourceDefinition",
          title     = "Go to source definition",
          arguments = { params.textDocument.uri, params.position },
        }, { bufnr = bufnr }, function(err, result)
          local function is_bundle(location)
            local uri = location.uri or location.targetUri or ""
            -- バンドル済みファイル（.js/.mjs/.cjs）はソース定義として不適切
            return uri:match("%.m?[jc]s$") ~= nil
          end

          local valid = vim.tbl_filter(function(loc)
            return not is_bundle(loc)
          end, result or {})

          if err or #valid == 0 then
            -- バンドルファイルが返された場合: textDocument/definition を同じ params で呼ぶ
            -- Telescope 経由だとカーソル位置を再取得するため結果が異なる可能性があるため
            -- params（_typescript.goToSourceDefinition と同じカーソル位置）を直接渡す
            client:request("textDocument/definition", params, function(def_err, def_result)
              local locations = vim.islist(def_result) and def_result or (def_result and { def_result } or {})
              if not def_err and #locations > 0 then
                -- textDocument/definition が SplitPanel.d.ts 等を返した場合はそこへ飛ぶ
                if #locations == 1 then
                  vim.lsp.util.show_document(locations[1], client.offset_encoding, {
                    reuse_win = true, focus = true,
                  })
                else
                  local items = vim.lsp.util.locations_to_items(locations, client.offset_encoding)
                  require("telescope.builtin").quickfix({ items = items })
                end
              else
                -- textDocument/definition も失敗: .d.ts バリアントを最終フォールバックとして開く
                -- （例: dist/index.mjs → dist/index.d.ts）
                if result and #result > 0 and is_bundle(result[1]) then
                  local loc = result[1]
                  local dts_uri = (loc.uri or loc.targetUri or ""):gsub("%.m?[jc]s$", ".d.ts")
                  local dts_path = vim.uri_to_fname(dts_uri)
                  if vim.fn.filereadable(dts_path) == 1 then
                    vim.lsp.util.show_document(
                      vim.tbl_extend("force", loc, { uri = dts_uri, targetUri = dts_uri }),
                      client.offset_encoding,
                      { reuse_win = true, focus = true }
                    )
                    return
                  end
                end
                vim.notify("No definition found", vim.log.levels.WARN)
              end
            end, bufnr)
          elseif #valid == 1 then
            vim.lsp.util.show_document(valid[1], client.offset_encoding, {
              reuse_win = true,
              focus     = true,
            })
          else
            local items = vim.lsp.util.locations_to_items(valid, client.offset_encoding)
            require("telescope.builtin").quickfix({ items = items })
          end
        end)
      end, { noremap = true, silent = true, buffer = bufnr, desc = "定義へジャンプ（ソース実装）" })
    end,

    filetypes = {
      "typescript", "typescriptreact",
      "javascript", "javascriptreact",
    },
    -- root_dir: tsconfig.json を優先し、worktree 環境でも front/ をルートとして検出する
    -- root_markers は nvim-lspconfig が root_dir を持つ場合に無視されるため、
    -- コールバック形式（function(bufnr, on_dir)）で明示的に上書きする
    root_dir = function(bufnr, on_dir)
      on_dir(vim.fs.root(bufnr, { "tsconfig.json", "jsconfig.json", "package.json", ".git" }))
    end,
    single_file_support = true,
  })
end
