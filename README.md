# [Jkproof](https://rubygems.org/gems/jkproof)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/jkproof`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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
word1:
  correct : correct_word_1
  wrongs  :
    word1 : wrong-word-1
    word2 : WrongWord1
word2:
  correct : CorrectWord2
  wrongs  :
    word1 : wrong_word_2
    word1 : wrongword2
```

一つの単号に対して、誤りのある単語を複数追加できます。

必ず文字数が多いものから降順になるように並べてください。

```yml
# いい例
wrongs  :
  word1 : wrong-word-1
  word2 : WrongWord1
  word3 : Wrong1

# 悪い例
wrongs  :
  word1 : Wrong1
  word2 : WrongWord1
  word3 : wrong-word-1
```

### Yahoo! APIキーを追加する

**jkproof/lib/jkproof/sentence.rb**

```ruby
      reqest.set_form_data(
        appid: 'YAHOO_API_KEY', # ここを書き換える
        　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　# ref : http://developer.yahoo.co.jp/webapi/jlp/kousei/v1/kousei.html
        sentence: @buf,
        no_filter: '11'
      )
```

## Usage

```ruby
# 検出された場合
Jkproof.detect_words_has_error("検知したい文章", "config/dictionary.yml")
# => [{ wrong: WrongWord, correct:CorrectWord }]

# 検出されなかった場合
Jkproof.detect_words_has_error("", "config/dictionary.yml")
# => []
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/jkproof.
