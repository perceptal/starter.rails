class RolesController < PeopleItemsController
  respond_to :html, :json
  
  expose(:roles) { staff.primary_group.roles }
  
  def show
    render "index"
  end
  
  def create
    staff.user.update_attributes(params[:user])
    if staff.user.save
      flash.now.notice = t :success
    else
      flash.now.alert = t :error
    end
    render "index"
  end
end
