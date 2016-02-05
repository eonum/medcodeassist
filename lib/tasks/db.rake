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

  task :seed_wordvectors_from_file, [:file, :vector_size] => :environment do |t, args|
    Rails.env = 'test'
    CSV.foreach(args.file, col_sep: ' ') do |row|
      token = Token.where(name: row[0]).first
      if token
        token.wordvector = row[1..args.vector_size.to_i].collect {|x| x.to_f}
        token.save
      end
    end
  end

  task :seed_token_names_from_file, [:file] => :environment do |t, args|
    Rails.env = 'test'
    db_config = Mongoid::Config::Environment.load_yaml("config/mongoid.yml")['sessions']['default']
    collection = 'tokens'
    sh "mongo #{db_config['database']} --eval 'db.#{collection}.drop()'"
    sh "mongoimport --db #{db_config['database']} --collection #{collection} --type csv --file #{args.file} --fields 'name'"
  end
end
