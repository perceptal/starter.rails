class Admin::PermissionsController < Admin::GroupController
  respond_to :html, :json

  expose(:group) { Group.find params[:organisation_id] }
  expose(:area) { "organisations" }

  expose(:roles) { group.roles }
  expose(:role)
  
  def show
    render "index"
  end
  
  def index
    flash.now[:warning] = t :error if roles.empty?

    respond_with roles
  end

  def new
  end

  def create
    role = group.roles.build(params[:role])
    
    if group.save
      flash.now.notice = t :success
      render "index"
    else
      flash.now.alert = t :error
      render "new"
    end  
  end
  
  def update    
    if role.update_attributes(params[:role])
      role.update_permissions(params[:permissions])
      
      flash.now.notice = t :success
    else
      flash.now.alert = t :error
    end
    render "index"
  end
end