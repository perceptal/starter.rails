require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  unless defined?(Rails)
    require File.expand_path("../../config/environment", __FILE__)
  end

  require 'rspec/rails'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
    config.include Factory::Syntax::Methods
    config.before(:each) { Mongoid::IdentityMap.clear }

    ActiveSupport::Dependencies.clear
  end  
end

Spork.each_run do
  load "#{Rails.root}/config/routes.rb" 
  Dir["#{Rails.root}/app/**/*.rb"].each { |f| load f }
end 