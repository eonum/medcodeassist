module Code
  def self.included base
    base.extend ClassMethods

    base.field :code, :type => String
    base.field :short_code, :type => String
    base.field :text_de, :type => String
    base.field :text_fr, :type => String
    base.field :text_it, :type => String
    base.field :version, :type => String
    base.field :average_wordvector, type: Array

    base.has_and_belongs_to_many :tokens
  end

  module ClassMethods
    def find_similar_codes(input_wordvector, count)
      if input_wordvector.nil?
        return {}
      end

      similar_codes = []
      self.all.each do |code|
        current_similarity = Measurable.cosine_similarity(code.average_wordvector, input_wordvector)
        if similar_codes.size < count
          similar_codes.push({code: code, similarity: current_similarity})
          similar_codes.sort_by!{|t| t[:similarity]}.reverse!
        else
          if similar_codes[-1][:similarity] < current_similarity
            similar_codes.pop
            similar_codes.push({code: code, similarity: current_similarity})
            similar_codes.sort_by!{|t| t[:similarity]}.reverse!
          end
        end
      end
      similar_codes.collect {|x| {code: x[:code].code, similarity: x[:similarity]}}
    end
  end
end