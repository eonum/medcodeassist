class Token
  include Mongoid::Document
  field :name, type: String
  def self.find_tokens text
    words = []
    tokens = []

    del = [' ', '.', ',', '?', '!']
    old_pos = 0
    for pos in 0..text.length
      if del.include? text[pos] or pos == text.length
        words.append({word: text[old_pos..pos-1], pos: old_pos})
        old_pos = pos+1
      end
    end

    words.each do |word|
      token = Token.find_token word[:word]
      if token
        tokens.append({word: word[:word], token: token.name, pos: word[:pos]})
      end
    end
    tokens
  end

  def self.find_token word
    stemmer = Lingua::Stemmer.new language: 'de'
    stemmed_word = stemmer.stem word
    Token.where(name: stemmed_word).first
  end
end
