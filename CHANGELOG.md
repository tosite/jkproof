# ChangeLog

## v1.2.0
- JSON形式に対応した
  - `Jkproof.detect_words_has_error(sentence, json_dictionary)` のように第二引数にJSONデータを渡すことで対応可能
- `type` の `local` を `yml` と `json` に細分化した

## v1.1.3
- 表記揺らぎのある用語が複数個あった場合にすべて表示されないバグの修正
  - 例：`"問合せ／問い合わせ／問い合せ" => [{wrong: "問い合わせ" correct: "お問い合わせ"}]`
- 戻り値に `type` （ `local` or `Yahoo` ）を追加した
  - どちらの辞書で誤りを検知したか特定しやすくするため

## v1.1.2
- `gemspec` ファイルの微修正

## v1.1.1
- `.env` 側に `NO_FILTER` を設定しない場合、API側の誤り検知レベルを最大にするようにした

## v1.1.0

- 辞書ファイルの記述を簡略化できるよう修正した
- API側の誤り検知レベルを `.env` から調整できるようにした
- `正しい単語の文字長 < 誤りのある単語の文字長` を検知できるようにした

```ruby
# dictionary.yml
# -
#   correct: word
#   wrongs:
#     - words

# 修正前：
Jkproof.detect_words_has_error("words is wrong.")
# => []

# 修正後：
Jkproof.detect_words_has_error("words is wrong.")
# => [{ correct: "word", wrong: "words" }]

# これは内部的な処理が次のようになっていたため発生していた。
# 1.正しい単語を除去
# 2.誤りのある単語を検知
```

## v1.0.0

- APIキー・辞書ファイルのパス（ `dictionary.yml` ）を `.env` に記述できるようにした 

正式版としてリリース。

## v0.1.0
プレリリース。
