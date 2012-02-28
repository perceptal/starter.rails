class SessionsController < AnonymousController
  respond_to :html

  expose(:code) do
    if cookies[:code].nil?
      if domain_specified
        group = Group.find_by_code_and_is_primary(request.subdomain, true)
        if !group.nil?
          group.code
        end
      end
    else
      cookies[:code]
    end
  end
  
  expose(:domain_specified) { request.subdomain.present? && request.subdomain != "www" && request.subdomain != DOMAIN_NAME }
  expose(:email) { cookies[:email] }

  def new
    session[:user_id] = nil
  end

  def create
    user = User.authenticate(params[:code], params[:email], params[:password])
      
    if user  
      session[:user_id] = user.id
      
      user.ip = request.remote_ip
      user.save
      
      remember
      
      if user.force_password_change != false
        redirect_to password_url, :notice => t(:password)
      else
        redirect_to dashboard_url, :notice => t(:success)
      end
    else
      flash.now.alert = t :error
      render "new"
    end
  end

  def destroy
    sign_out
    redirect_to home_url, :notice => t(:success)
  end
  
  private
  
  def remember
    cookies.permanent[:code] = params[:code]
    if params[:remember_me]
      cookies.permanent[:email] = params[:email]
    else
      cookies.delete :email
    end
  end
end