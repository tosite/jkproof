# frozen_string_literal: true

module Jkproof
  class Sentence
    require 'yaml'
    require 'uri'
    require 'dotenv'
    require 'net/https'
    require 'active_support'
    require 'active_support/core_ext'

    def initialize(buf)
      Dotenv.load
      yml_path       = ENV['DICTIONARY_YML_PATH']
      @yahoo_api_key = ENV['YAHOO_API_KEY']
      @no_filter     = ENV['NO_FILTER'].blank? ? '' : ENV['NO_FILTER']

      begin
        @dictionary_words = yml_path.blank? ? [] : YAML.load_file(yml_path)
      rescue StandardError => e
        raise "#{e}(file_path: '#{yml_path}')"
      end
      @yahoo_words = []
      @buf         = buf
      fetch_yahoo_lint_words
    end

    def fetch_wrong_words
      wrong_words           = []
      excluded_correct_word = @buf

      # 正しいワードを取り除く
      @dictionary_words.each do |word|
        # 誤りのある単語の文字数 > 正しい単語の文字数の場合、先に検知する
        wrongs = fetch_wrong_words_than_long_correct_word(word['correct'], word['wrongs'])
        wrongs.each do |wrong|
          if excluded_correct_word.include?(wrong)
            wrong_words.push(correct: word['correct'], wrong: wrong)
            excluded_correct_word = excluded_correct_word.gsub(wrong, '####')
          end
        end
        # 正しいワードを取り除く
        excluded_correct_word = excluded_correct_word.gsub(word['correct'], '****')
      end

      @dictionary_words.each do |word|
        correct_word = word['correct']
        word['wrongs'].each do |wrong|
          if excluded_correct_word.include?(wrong)
            wrong_words.push(wrong: wrong, correct: correct_word)
            break
          end
        end
      end
      wrong_words.concat(@yahoo_words).uniq
    end

    private

    def fetch_yahoo_lint_words
      if @yahoo_api_key.blank? || @yahoo_api_key.size < 10
        raise "There is no Yahoo API Key.Please set API Key in 'jkproof/.env'.(ref: https://e.developer.yahoo.co.jp/dashboard/)"
      end

      # ref: http://developer.yahoo.co.jp/webapi/jlp/kousei/v1/kousei.html
      uri          = URI.parse('https://jlp.yahooapis.jp/KouseiService/V1/kousei')
      http         = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      reqest       = Net::HTTP::Post.new(uri.path)
      reqest.set_form_data(
        appid: @yahoo_api_key,
        sentence: @buf,
        no_filter: @no_filter
      )
      s = http.request(reqest).body
      unless Hash.from_xml(s)['ResultSet']['Result'].nil?
        [Hash.from_xml(s)['ResultSet']['Result']].flatten.each do |r|
          next unless r['Surface']
          next unless r['ShitekiWord']

          @yahoo_words.push(correct: r['ShitekiWord'], wrong: r['Surface'])
        end
      end
    end

    def fetch_wrong_words_than_long_correct_word(correct_word, wrong_words)
      return_words = []
      c_length     = correct_word.length
      wrong_words.each { |wrong_word| return_words.push(wrong_word) if c_length < wrong_word.length }
      return_words
    end
  end
end
