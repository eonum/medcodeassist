class IcdCode
  include Mongoid::Document

  field :short_code, :type => String
  field :code, :type => String
  field :text_de, :type => String
  field :text_fr, :type => String
  field :text_it, :type => String
  field :version, :type => String

  field :average_wordvector, type: Array

  has_and_belongs_to_many :tokens
end