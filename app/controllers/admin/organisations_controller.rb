class Admin::OrganisationsController < Admin::GroupController
  respond_to :html, :json
  
  expose(:groups) { Group.secured(current_user.person.security_key).find_all_by_is_primary true }
  expose(:group)
  
  def index
    if groups.count == 1
      redirect_to admin_organisation_url(groups.first) 
    else
      respond_with groups
    end
  end

  def show
    respond_with group
  end
  
  def new
  end

  def create
    group.update_attributes params[:group]
    group.setup_as_organisation
    
    if group.save
      flash.now.notice = t :success
      render "show", :id => group.id
    else
      flash.now.alert = t :error
      render "new"
    end
  end

  def update
    if group.update_attributes params[:group]
      flash.now.notice = t :success
    else
      flash.now.alert = t :error
    end
    render "show"
  end

  def destroy
  end
end
