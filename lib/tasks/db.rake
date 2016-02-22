require 'csv'

namespace :db do
  desc 'Delete all contents of the test DB and seed it with the contents in test/testdata/json-fixtures'
  task :seed_test_data => :environment do
    Rails.env = 'test'
    db_config = Mongoid::Config::Environment.load_yaml("config/mongoid.yml")['sessions']['default']
    model_paths = Dir["#{Rails.root}/app/models/**/*.rb"]
    sanitized_model_paths = model_paths.map { |path| path.gsub(/.*\/app\/models\//, '').gsub('.rb', '') }
    model_constants = sanitized_model_paths.map do |path|
      path.split('/').map { |token| token.camelize }.join('::').constantize
    end
    model_constants = model_constants.select { |constant| constant.include?(Mongoid::Document) }

    collections = model_constants.map{|model| model.collection_name}.uniq

    collections.each do |collection|
      sh "mongo #{db_config['database']} --eval 'db.#{collection}.drop()'"
      sh "mongoimport --db #{db_config['database']} --collection #{collection} < test/testdata/json-fixtures/#{collection}.json"
    end
  end

  desc 'Dump all contents of the test DB to test/testdata/json-fixtures'
  task :dump_test_data => :environment do
    Rails.env = 'test'
    db_config = Mongoid::Config::Environment.load_yaml("config/mongoid.yml")['sessions']['default']

    model_paths = Dir["#{Rails.root}/app/models/**/*.rb"]
    sanitized_model_paths = model_paths.map { |path| path.gsub(/.*\/app\/models\//, '').gsub('.rb', '') }
    model_constants = sanitized_model_paths.map do |path|
      path.split('/').map { |token| token.camelize }.join('::').constantize
    end
    model_constants = model_constants.select { |constant| constant.include?(Mongoid::Document) }

    collections = model_constants.map{|model| model.collection_name}.uniq

    collections.each do |collection|
      sh "mongoexport --db #{db_config['database']} --collection #{collection} > test/testdata/json-fixtures/#{collection}.json"
    end
  end

  task :seed_wordvectors_from_file, [:file, :lang] => :environment do |t, args|
    Rails.env = 'test'
    csv = CSV.read(args.file, col_sep: ' ')
    vector_size = csv.shift[1]
    csv.shift
    csv.each do |row|
      token = Token.where({name: row[0], lang: args.lang}).first
      if token
        token.wordvector = row[1..vector_size.to_i].collect {|x| x.to_f}
        token.save
      end
    end
  end

  task :seed_token_names_from_file, [:file, :lang] => :environment do |t, args|
    Rails.env = 'test'
    db_config = Mongoid::Config::Environment.load_yaml("config/mongoid.yml")['sessions']['default']
    collection = 'tokens'
    sh "mongo #{db_config['database']} --eval 'db.#{collection}.drop()'"

    CSV.foreach(args.file, col_sep: ' ') do |row|
      if row[0]
        token = Token.new
        token.name = row[0]
        token.lang = args.lang
        token.save
      end
    end
  end

  task :correlate_codes_and_tokens, [:file, :lang] => :environment do |t, args|
    Rails.env = 'test'
    file = File.read(args.file)
    codes_tokens = JSON.parse(file)

    codes_tokens.each do |key, tokens|
      tokens.each do |t|
        token = Token.where({name: t, lang: args.lang}).first
        if token
          if key.start_with? "DRG_"
            drg = Drg.where({code: key[4..-1]})
            if drg
              print "Correlating DRG #{drg.code} with token #{t}\n"
              drg.tokens.push(token)
            end

          elsif key.start_with? "CHOP_"
            chop = ChopCode.where({code: token.name[5..-1]})
            if chop
              print "Correlating CHOP code #{chop.code} with token #{t}\n"
              chop.tokens.push(token)
            end

          elsif key.start_with? "ICD_"
            icd = IcdCode.where({code: key.name[4..-1]})
            if icd
              print "Correlating ICD code #{icd.code} with token #{t}\n"
              icd.tokens.push(token)
            end

          else
            print "Token #{t} couldn't be correlated with any code."
          end
        end
      end
    end

  end

end
