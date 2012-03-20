class StaffController < PeopleController  
  respond_to :html, :json

  before_filter :authorise_read, :only => [:search_active]
  before_filter :authorise_update, 
    :only => [:update_employment, :terminate, :save_terminate, :lock, :unlock, :reset_password]
  
  expose(:staff) 
  
  def search
    respond_with results 
  end
  
  def search_active
    respond_with results true
  end
  
  def new
    staff.build_user
  end
  
  def create
    staff.attributes = params[:staff]
    staff.join_group Group.find params[:staff][:group_id]
    
    if staff.save
      current_user.people << staff if current_user
      
      flash.now.notice = t :success, :name => staff.full_name
      render "show", :id => staff.id
    else
      flash.now.alert = t :error
      render "new"
    end
  end
  
  def update
    save
    render "show"
  end
  
  def update_employment
    staff.join_group Group.find params[:staff][:group_id]
    save
    render "employment"
  end
  
  def terminate
    staff.left_on = Date.today
  end
  
  def save_terminate
    if staff.leave params[:staff][:reason_for_leaving], params[:staff][:left_on]
      flash.now.notice = t :success, :name => staff.full_name
      render "show"
    else
      flash.now.alert = t :error
      render "terminate"
    end
  end
  
  def lock
    staff.user.lock
    flash.now[:warning] = t :success
    render "show"
  end
  
  def unlock
    staff.user.unlock
    flash.now.notice = t :success
    render "show"
  end
  
  def reset_password
    staff.user.reset_password params[:staff][:password]
    staff.user.force_password_change = true
    staff.user.is_locked = false
    staff.user.save
    flash.now.notice = t :success
    render "show"
  end
  
  def destroy
    staff.join_group Group.where(:name => "Archive").first
    if staff.leave "Archived", Date.today
      flash.now.notice = t :success, :name => staff.full_name
    else
      flash.now.alert = t :error
    end
    render "index"
  end
  
  private
  
  def save
    if staff.update_attributes(params[:staff])
      flash.now.notice = t :success
    else
      flash.now.alert = t :error
    end
  end
  
  def results(active_only=false)
    query = "(UPPER(first_name) LIKE :query OR UPPER(last_name) LIKE :query OR UPPER(first_name||' '||last_name) LIKE :query)"
    query = "left_on IS NULL AND " + query if active_only
    
    if params[:q] && params[:q].length > 0
      Staff.secured(security_key).where(query, :query => params[:q].upcase + "%")
    else
      if params[:id] && params[:id].length > 0
        Staff.find(params[:id])
      else
        []
      end
    end  
  end
end
