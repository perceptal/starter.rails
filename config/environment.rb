# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Starter::Application.initialize!

APP_VERSION = `git describe --always` unless defined? APP_VERSION