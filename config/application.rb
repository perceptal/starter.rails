require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"

Bundler.require *Rails.groups(:assets) if defined?(Bundler)

module Starter
  class Application < Rails::Application
    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"
    
    config.generators do |g|
      g.view_specs true
      g.helper_specs true
      g.test_framework :rspec
      g.stylesheet_engine :sass
      g.template_engine :slim
    end
    
    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.initialize_on_precompile = false
    
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    
    if File.exists?("#{Rails.root}/config/files/s3.yml")
      s3_config = YAML.load_file("#{Rails.root}/config/files/s3.yml")

      config.s3_key = s3_config[Rails.env]['key']
      config.s3_secret = s3_config[Rails.env]['secret']
      config.s3_bucket = s3_config[Rails.env]['bucket'].to_s
    else
      config.s3_key = ENV['S3_KEY'] 
      config.s3_secret = ENV['S3_SECRET']
      config.s3_bucket = ENV['S3_BUCKET'] 
    end
        
    if Rails.env.test? 
      initializer :after => :initialize_dependency_mechanism do 
        ActiveSupport::Dependencies.mechanism = :load 
      end 
    end
  end
end
