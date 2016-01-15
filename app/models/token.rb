class Token
  include Mongoid::Document
  field :name, type: String

  def self.find_token word
    stemmer = Lingua::Stemmer.new language: 'de'
    stemmed_word = stemmer.stem word
    Token.where(name: stemmed_word).first
  end
end
