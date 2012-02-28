class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :init, :set_locale
  
  PAGE_SIZE = 8.freeze unless defined? PAGE_SIZE
  DOMAIN_NAME = "starter".freeze unless defined? DOMAIN_NAME
  
  expose(:page) { get_page :p }
  expose(:skip) { get_skip page }
  expose(:limit) { PAGE_SIZE } 
  
  layout :get_layout

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, :with => :render_error
    rescue_from CanCan::AccessDenied, :with => :render_access_denied
    rescue_from ActionController::RoutingError, :with => :render_not_found
    #rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  end
  
  expose(:current_user) do
    if session[:user_id]
      if User.exists? session[:user_id]
        User.find(session[:user_id]) 
      else
        session[:user_id] = nil
      end
    end
  end
  
  expose(:force_password_change) do
    !(current_user.nil? || current_user.force_password_change == false)
  end
 
  def set_locale
    I18n.locale = extract_locale_from_accept_language_header
  end
  
  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
     
  def init
    @start_time = Time.now
  end
    
  def get_layout
    request.xhr? ? "remote" : "application"
  end
  
  def render(*args) 
    @template_name = args[0] if args[0]
    super
  end

  def sign_out
    current_user.last_sign_on = DateTime.now
    current_user.save
    
    session[:user_id] = nil
  end

  def render_not_found
    flash.now.alert = I18n.t :not_found, :scope => "error"
    render :template => "/errors/404", :status => 404
  end
  
  def render_access_denied
    flash.now.alert = I18n.t :access_denied, :scope => "error"
    render :template => "/errors/401", :status => 401
  end

  def render_error(exception)
    @message = exception.message
    logger.error exception
    puts "ERROR " + exception.to_s
    #puts exception.backtrace.join("\n")
    flash.now.alert = I18n.t :application, :scope => "error"
    render :template => "/errors/500", :status => 500
  end

  protected
  
  def d(date)
    Date.civil(date[0,4].to_i, date[4,2].to_i, date[6,2].to_i)
  end
  
  def f(date)
    date.strftime("%Y%m%d")
  end
  
  def t(symbol, options = {})
    I18n.t symbol, { :scope => "#{controller_name}.#{action_name}" }.update(options)
  end
  
  def get_page(param)
    params[param].nil? || params[param].to_i.to_s != params[param] ? 1 : params[param].to_i
  end
  
  def get_skip(p, size=PAGE_SIZE)
    (p * size) - size
  end
end
