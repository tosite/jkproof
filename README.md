<img src="https://github.com/tosite0345/jkproof/blob/master/docs/logo.png" style="width: 100% !important;">

# [Jkproof](https://rubygems.org/gems/jkproof)

**Author:[@mao_sum](https://twitter.com/mao_sum)**

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/jkproof`. To experiment with that code, run `bin/console` for an interactive prompt.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jkproof'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jkproof

### `dictionary.yml` を任意の場所に追加する

`config/dictionary.yml` など、好きな場所に辞書ファイルを準備します。  

**config/dictionary.yml**  
```yml
-
  correct : correct_word_1
  wrongs  :
    - wrong-word-1
    - WrongWord1
-
  correct : CorrectWord2
  wrongs  :
    - wrong_word_2
    - wrongword2
```

一つの単号に対して、誤りのある単語を複数追加できます。

必ず文字数が多いものから降順になるように並べてください。


```yml
# いい例
wrongs  :
  - wrong-word-1
  - WrongWord1
  - Word1

# 悪い例
wrongs  :
  - Word1
  - WrongWord1
  - wrong-word-1
# 悪い例では文章に "WrongWord1" が与えられた場合、 "Word1" を返してしまう
```

### Yahoo APIキーを生成する
https://e.developer.yahoo.co.jp/dashboard/ からAPIキーを生成してください。

`Client ID` を使用します。

### .envファイルを修正する

`jkproof/.env.sample` をコピーして編集、もしくは既存の `.env` ファイルに追記してください。

**追記する場合**

```
YAHOO_API_KEY=""
DICTIONARY_YML_PATH=""
NO_FILTER=""
```

先に作成した辞書ファイルのパスを `DICTIONARY_YML_PATH` に、Yahoo APIキーを `YAHPP_API_KEY` にそれぞれ登録してください。  
`NO_FILTER` を設定することで検出する精度を調整することができます。  
設定値については [こちら](https://developer.yahoo.co.jp/webapi/jlp/kousei/v1/kousei.html) のno_filterをご覧ください。  
なお、複数の除外項目を設定する場合は `NO_FILTER="11,12,13"` のようにカンマ区切りの文字列で指定するようお願いいたします。

## Usage

```ruby
# 検出された場合
Jkproof.detect_words_has_error("検知したい文章")
# => [{ wrong: WrongWord, correct:CorrectWord }]

# 検出されなかった場合
Jkproof.detect_words_has_error("")
# => []
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tosite0345/jkproof.
