# Seed DRGs
puts "Seeding DRGs"
Drg.delete_all
drg_keys = [:code, :short_code, :text_de, :text_fr, :text_it, :version, :cost_weight, :first_day_surcharge, :first_day_discount, :surcharge_per_day, :discount_per_day, :avg_duration, :transfer_flatrate, :partition]
csv = CSV.read("db/seeds/drgs.csv", col_sep: ',')
csv.shift
csv.each do |row|
  Drg.create(Hash[row.map.with_index{|e, i| [drg_keys[i], e]}])
end
Drg.where(short_code: nil).each do |drg|
  drg.short_code = drg.code
  drg.save!
end

# Seed ICDs
puts "Seeding ICDs"
IcdCode.delete_all
icd_keys = [:code, :short_code, :text_de, :text_fr, :text_it, :version]
csv = CSV.read("db/seeds/icd_codes.csv", col_sep: ',')
csv.shift
csv.each do |row|
  IcdCode.create(Hash[row.map.with_index{|e, i| [icd_keys[i], e]}])
end
IcdCode.where(short_code: nil).each do |drg|
  icd.short_code = icd.code
  icd.save!
end

# Seed CHOPs
puts "Seeding CHOPs"
ChopCode.delete_all
chop_keys = [:code, :short_code, :text_de, :text_fr, :text_it, :version]
csv = CSV.read("db/seeds/chop_codes.csv", col_sep: ',')
csv.shift
csv.each do |row|
  ChopCode.create(Hash[row.map.with_index{|e, i| [chop_keys[i], e]}])
end
ChopCode.where(short_code: nil).each do |drg|
  chop.short_code = icd.code
  chop.save!
end