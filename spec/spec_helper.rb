require 'spork'

# Loading more in this block will cause your tests to run faster.
# if you change any configuration or code from libraries loaded
# need to restart spork for it take effect.
Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'

  require 'rails/application'
  require 'rails/mongoid'
  require 'capybara/rspec'
  Spork.trap_class_method(Rails::Mongoid, :load_models)
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  # Capybara.javascript_driver = :webkit

  Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each {|f| require f}

  require File.dirname(__FILE__) + "/../config/environment.rb"
  #.  After this line is too late.

  require 'rspec/rails'

  RSpec.configure do |config|

    config.include Mongoid::Matchers

    config.order = "random"
    config.infer_base_class_for_anonymous_controllers = false
    config.before(:suite) do
      DatabaseCleaner[:mongoid].strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner[:mongoid].start
    end

    config.after(:each) do
      DatabaseCleaner[:mongoid].clean
    end

    config.mock_with :rspec
  end
end
