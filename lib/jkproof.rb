require 'jkproof/version'
require 'jkproof/sentence'

module Jkproof
  class Error < StandardError; end

  def self.detect_words_has_error(sentence)
    obj = Sentence.new(sentence)
    obj.fetch_wrong_words
  end
end
