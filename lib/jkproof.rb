require 'jkproof/version'
require 'jkproof/sentence'
require 'yaml'
require 'uri'
require 'net/https'
require 'active_support'
require 'active_support/core_ext'

module Jkproof
  class Error < StandardError; end

  def self.detect_words_has_error(sentence, dictionary_yml_path)
    obj = Sentence.new(sentence, dictionary_yml_path)
    obj.fetch_wrong_words
  end
end
