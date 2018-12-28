RSpec.describe Jkproof do
  it 'バージョンを持っている' do
    expect(Jkproof::VERSION).not_to be nil
  end

  it 'yml側の辞書に合致する場合' do
    expect = [
      { wrong: 'お問合せ', correct: 'お問い合わせ' }
    ]
    buf    = "やめてください！\nお問合せ（お問い合わせ）は懇切丁寧にお答えいたします。"
    actual = Jkproof.detect_words_has_error(buf, './spec/dictionary.yml')
    expect(actual).to eq expect
  end

  it 'Yahooの辞書に合致する場合' do
    expect = [
      { correct: 'ください', wrong: '下さい' },
      { correct: 'いたします', wrong: '致します' }
    ]
    buf    = "やめて下さい！\nお問い合わせは懇切丁寧にお答え致します。"
    actual = Jkproof.detect_words_has_error(buf, './spec/dictionary.yml')
    expect(actual).to eq expect
  end

  it 'どちらも合致する場合' do
    expect = [
      { wrong: 'お問合せ', correct: 'お問い合わせ' },
      { correct: 'ください', wrong: '下さい' },
      { correct: 'いたします', wrong: '致します' }
    ]
    buf    = "やめて下さい！\nお問合せ（お問い合わせ）は懇切丁寧にお答え致します。"
    actual = Jkproof.detect_words_has_error(buf, './spec/dictionary.yml')
    expect(actual).to eq expect
  end

  it '用語が複数個ある場合' do
    expect = [
      { wrong: 'お問合せ', correct: 'お問い合わせ' },
      { correct: 'ください', wrong: '下さい' },
      { correct: 'いたします', wrong: '致します' }
    ]
    buf    = "やめて下さい！\nお問合せお問合せは懇切丁寧にお答え致します。\n下さい。"
    actual = Jkproof.detect_words_has_error(buf, './spec/dictionary.yml')
    expect(actual).to eq expect
  end

  it '用語がない場合' do
    expect = []
    buf    = 'これはきれいな日本語です。'
    actual = Jkproof.detect_words_has_error(buf, './spec/dictionary.yml')
    expect(actual).to eq expect
  end

  it '対象文字が空の場合' do
    expect = []
    buf    = ''
    actual = Jkproof.detect_words_has_error(buf, './spec/dictionary.yml')
    expect(actual).to eq expect
  end
end
