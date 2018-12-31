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
      yml_path          = ENV["DICTIONARY_YML_PATH"]
      @yahoo_api_key    = ENV["YAHOO_API_KEY"]
      @dictionary_words = (yml_path.blank?) ? [] : YAML.load_file(yml_path)
      @yahoo_words      = []
      @buf              = buf
      fetch_yahoo_lint_words
    end

    def fetch_wrong_words
      wrong_words = []

      # 正しいワードを取り除く
      @dictionary_words.each do |_key, word|
        @buf.gsub!(word['correct'], '')
      end

      @dictionary_words.each do |_key, word|
        correct_word = word['correct']
        word['wrongs'].each do |_wkey, wrong|
          if @buf.include?(wrong)
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
        no_filter: '11'
        # no_filter: "11,12,14,15"
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

    def remove_correct_word(key, correct_word)
      @buf.gsub!(correct_word, "[###{key}##]")
    end
  end
end
