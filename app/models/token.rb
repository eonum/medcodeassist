class Token
  include Mongoid::Document
  field :name, type: String
  field :wordvector, type: Array
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

  def find_similar_tokens
    most_similar_token = nil
    max_similarity = 0
    Token.all.each do |token|
      if token.wordvector and token != self
        current_similarity = Measurable.cosine_similarity(self.wordvector, token.wordvector)
        if max_similarity < current_similarity
          max_similarity = current_similarity
          most_similar_token = token
        end
      end
    end
    most_similar_token
  end

end
