module Jkproof
  class Sentence
    require 'yaml'
    require 'uri'
    require 'net/https'
    require 'active_support'
    require 'active_support/core_ext'

    def initialize(buf, yml_path)
      @dictionary_words = YAML.load_file(yml_path)
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
      # ref: http://developer.yahoo.co.jp/webapi/jlp/kousei/v1/kousei.html
      uri          = URI.parse('https://jlp.yahooapis.jp/KouseiService/V1/kousei')
      http         = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      reqest       = Net::HTTP::Post.new(uri.path)
      reqest.set_form_data(
        appid: 'YAHOO_API_KEY',
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
