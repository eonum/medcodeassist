class Token
  include Mongoid::Document
  field :name, type: String
  field :lang, type: String
  field :wordvector, type: Array

  has_and_belongs_to_many :chop_codes
  has_and_belongs_to_many :icd_codes
  has_and_belongs_to_many :drgs

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

  def find_similar_tokens(count=5,  minimal_token_length=1, prefix='')
   similar_tokens = []
    Token.all.each do |token|
      if token.wordvector and token != self and (prefix.nil? or token.name.start_with? prefix) and token.name.length >= minimal_token_length + prefix.length
        current_similarity = Measurable.cosine_similarity(self.wordvector, token.wordvector)
        if similar_tokens.size < count
          similar_tokens.push({token: token, similarity: current_similarity})
          similar_tokens.sort_by!{|t| t[:similarity]}.reverse!
        else
          if similar_tokens[-1][:similarity] < current_similarity
            similar_tokens.pop
            similar_tokens.push({token: token, similarity: current_similarity})
            similar_tokens.sort_by!{|t| t[:similarity]}.reverse!
          end
        end
      end
    end
   similar_tokens.collect {|x| {token: x[:token].name, similarity: x[:similarity]}}
  end

end
