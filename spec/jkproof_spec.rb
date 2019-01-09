# frozen_string_literal: true

RSpec.describe Jkproof do
  describe "ローカルの辞書データを使う場合" do
    it 'バージョンを持っている' do
      expect(Jkproof::VERSION).not_to be nil
    end

    it 'yml側の辞書に合致する場合' do
      expect = [
        { wrong: 'お問合せ', correct: 'お問い合わせ' }
      ]
      buf    = "ください\nお問合せ\nお問い合わせ\nいたします"
      actual = Jkproof.detect_words_has_error(buf)
      expect(actual).to eq expect
    end

    it 'Yahooの辞書に合致する場合' do
      expect = [
        { correct: 'ください', wrong: '下さい' },
        { correct: 'いたします', wrong: '致します' }
      ]
      buf    = "下さい\nお問い合わせ\n致します"
      actual = Jkproof.detect_words_has_error(buf)
      expect(actual).to eq expect
    end

    it 'どちらも合致する場合' do
      expect = [
        { correct: 'お問い合わせ', wrong: 'お問合せ' },
        { correct: 'ください', wrong: '下さい' },
        { correct: 'いたします', wrong: '致します' }
      ]
      buf    = "下さい\nお問合せ\nお問い合わせ\n致します"
      actual = Jkproof.detect_words_has_error(buf)
      expect(actual).to eq expect
    end

    it '用語が複数個ある場合' do
      expect = [
        { wrong: 'お問合せ', correct: 'お問い合わせ' },
        { correct: 'ください', wrong: '下さい' },
        { correct: 'いたします', wrong: '致します' }
      ]
      buf    = "下さい\nお問合せ\nお問合せ\n致します"
      actual = Jkproof.detect_words_has_error(buf)
      expect(actual).to eq expect
    end

    it '用語がない場合' do
      expect = []
      buf    = 'これはきれいな日本語です。'
      actual = Jkproof.detect_words_has_error(buf)
      expect(actual).to eq expect
    end

    it '対象文字が空の場合' do
      expect = []
      buf    = ''
      actual = Jkproof.detect_words_has_error(buf)
      expect(actual).to eq expect
    end

    it '正しいワードよりも誤ったワードのほうが文字数が長い場合' do
      expect = [
        { wrong: '税抜き', correct: '税抜' }
      ]
      buf    = '税抜き表記は誤りです。税抜が正しい。'
      actual = Jkproof.detect_words_has_error(buf)
      expect(actual).to eq expect
    end
  end
end
