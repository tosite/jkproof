# ChangeLog

## v1.1.0

- 辞書ファイルの記述を簡略化できるよう修正した
- API側の検知レベルを `.env` から調整できるようにした
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
