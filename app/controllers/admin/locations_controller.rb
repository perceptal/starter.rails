class Admin::LocationsController < Admin::GroupController
  respond_to :html, :json
  
  expose(:group) { Group.find params[:organisation_id] }
  expose(:area) { "organisations" }

  expose(:locations) { Group.find_all_by_code_and_is_primary group.code, false }
  expose(:location) do
    if params[:id]
      Group.find(params[:id]) 
    else
      Group.new
    end
  end
  
  def show
    render "index"
  end
  
  def index
    flash.now[:warning] = t :error if locations.empty?
    
    respond_with locations
  end
  
  def new
  end
  
  def create
    location = group.children.build(params[:group])
    location.setup_as_location
    
    if location.save
      flash.now.notice = t :success
      render "index"
    else
      flash.now.alert = t :error
      render "new"
    end  
  end
  
  def update
    if location.update_attributes(params[:group])
      flash.now.notice = t :success
    else
      flash.now.alert = t :error
    end
    render "index"
  end
end