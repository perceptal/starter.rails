class UserController < AuthenticatedController
  respond_to :html, :json
  
  expose(:staff) { current_user.person }
  expose(:assigned) { [] }
  
  def save
    if staff.update_attributes params[:staff]
      flash.now.notice = t :success
    else
      flash.now.alert = t :error
    end
    
    render "profile"
  end
  
  def save_settings
    staff.change_keys Group.find params[:location]
    staff.save
    flash.now.notice = t :success
    render "settings"
  end
  
  def change_password
    if current_user.nil?
      redirect_to sign_in_path
    end
    
    existing, password, confirmation = params[:existing], params[:password], params[:confirmation]
    
    if password != confirmation
      flash.now.alert = t :confirm
    else
      if current_user.change_password(existing, password)
        flash.now.notice = t :success
        render "dashboard"
      else
        flash.now.alert = t :error
        render "password"
      end
    end
  end
end
