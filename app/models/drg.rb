class Drg
  include Mongoid::Document
  include Code

  field :cost_weight, :type => Float
  field :first_day_surcharge, :type => Integer
  field :first_day_discount, :type => Integer
  field :surcharge_per_day, :type => Float
  field :discount_per_day, :type => Float
  field :avg_duration, :type => Float
  field :transfer_flatrate, :type => Float
  field :partition, :type => String
end