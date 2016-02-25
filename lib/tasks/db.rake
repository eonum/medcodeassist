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

  desc 'Seed tokens and wordvectors from file'
  task :seed_tokens_and_wordvectors_from_file, [:file, :lang] => :environment do |t, args|
    Rails.env = 'test'
    db_config = Mongoid::Config::Environment.load_yaml("config/mongoid.yml")['sessions']['default']
    collection = 'tokens'
    sh "mongo #{db_config['database']} --eval 'db.#{collection}.drop()'"

    Rails.env = 'test'
    csv = CSV.read(args.file, col_sep: ' ')
    vector_size = csv.shift[1]
    csv.shift
    csv.each do |row|
      token = Token.new
      token.name = row[0]
      token.lang = args.lang
      token.wordvector = row[1..vector_size.to_i].collect {|x| x.to_f}
      token.save
    end
  end

  desc 'Correlate codes with tokens and calculate average wordvectors'
  task :correlate_codes_and_tokens_and_calculate_average_wordvectors, [:file, :lang] => :environment do |t, args|
    Rails.env = 'test'
    file = File.read(args.file)
    codes_tokens = JSON.parse(file)

    codes_tokens.each do |key, token_names|
      tokens = []
      token_names.each do |t|
        token = Token.where({name: t, lang: args.lang}).first
        if token
          tokens.push token
        end
      end

      if key.start_with? 'DRG_'
        code_class = Drg
        prefix_end = 3
      elsif key.start_with? 'CHOP_'
        code_class = ChopCode
        prefix_end = 4
      elsif key.start_with? 'ICD_'
        code_class = IcdCode
        prefix_end = 3
      else
        code_class = nil
        prefix_end = nil
      end

      if code_class and prefix_end
        code = code_class.where({short_code: key[prefix_end+1..-1]}).first
        if code
          print "Adding tokens to #{code.code}\n"
          tokens += code.tokens
          code.tokens = tokens

          sum = nil
          tokens.each do |token|
            if sum
              sum = [sum, token.wordvector].transpose.map{|x| x.reduce :+}
            else
              sum = token.wordvector.dup
            end
          end
          code.average_wordvector = sum.collect!{|x| x / sum.length.to_f}

          #print(code.average_wordvector)
          code.save
        else
          print "#{key} not found in database\n"
        end

      end

    end
  end



end
