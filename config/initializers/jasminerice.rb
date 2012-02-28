module Jasminerice
  
  module Starter
    extend ActiveSupport::Concern
    included do
      #delegate :foo_path, to: ::Rails.application.routes_url_helpers
    end
    def jasminerice?
      true
    end
    def current_user
      #@current_user ||= User.find(1)
    end
  end
  
  ApplicationHelper.send :include, Starter
  
  class SpecController < Jasminerice::ApplicationController
    def index
      render template: 'home', layout: 'application'
    end
  end
  
end if defined?(Jasminerice) && Jasminerice.environments.include?(Rails.env)
