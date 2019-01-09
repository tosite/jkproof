# frozen_string_literal: true

require 'jkproof/version'
require 'jkproof/sentence'

module Jkproof
  class Error < StandardError; end

  def self.detect_words_has_error(sentence, json_dictionary = '')
    obj = Sentence.new(sentence, json_dictionary)
    obj.fetch_wrong_words
  end
end
