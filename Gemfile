source 'http://rubygems.org'

gem 'rails', '~> 3.2.0'
gem 'pg', :group => [:development, :production]
gem 'thin'
gem 'heroku'
gem 'decent_exposure', '~> 1.0.1'
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'mongoid', '~> 2.2'
gem 'mongoid_taggable'
gem 'bson_ext'
gem 'cancan'
gem 'acts-as-taggable-on', '~> 2.1.0'
gem 'sunspot_rails'
gem 'jquery-rails'

group :assets do
  gem 'compass-rails'
  gem 'sass-rails',   '~> 3.2'
  gem 'coffee-rails', '~> 3.2'
  gem 'uglifier', '~> 1.0'
  gem 'i18n-js'
end

gem 'formtastic', :git => 'https://github.com/justinfrench/formtastic.git'
gem 'client_side_validations'
gem 'slim'
gem 'paperclip', '~> 2.4'
gem 'aws-s3'
gem 'aws-sdk'

group :development, :test do
#  gem 'jasmine', :group => [:development, :test]
  gem 'jasminerice'
  gem 'guard-jasmine'
  gem 'ruby_gntp'
  gem 'rspec-rails', '~> 2.6.1'
end

group :development do
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-pow'
  gem 'guard-livereload'
  gem 'guard-annotate'
  gem 'yajl-ruby'
  gem 'sunspot_solr'
  gem 'progress_bar'
end

group :test do
  gem 'mongoid-rspec', '~> 1.4.4'
  gem 'factory_girl_rails', '~> 1.2.0'
  gem 'cucumber-rails', '~> 0.5.2'
  gem 'capybara', '~> 1.0.0'
  gem 'rspec'
  gem 'spork'
  gem 'sqlite3'
  
  gem 'guard-spork'
  gem 'guard-rspec'
  
  gem 'rb-fsevent'  
  gem 'growl'
  gem 'turn', :require => false
end

gem 'database_cleaner', '~> 0.6.7'
