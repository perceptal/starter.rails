class AuthenticatedController < ApplicationController
  before_filter :authenticate!
  
  def authorise!(permission, resource)
    if !can? permission, resource
      if request.xhr?
        render :status => 401
      else
        render_access_denied
      end
    end
  end
  
  private
  
  def authenticate!
    if current_user.nil?
      if request.xhr?
        render :status => 401
      else
        redirect_to sign_in_path
      end
    end
  end
end