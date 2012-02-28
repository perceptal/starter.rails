class PeopleItemsController < AuthenticatedController
  before_filter :authorise_read, :only => [:show, :index]
  before_filter :authorise_update, :only => [:new, :create, :edit, :update, :destroy]

  expose(:person) { Person.find_by_id(person_id) }
  expose(:patient) { person if owner == "patient" }
  expose(:staff) { person if owner == "staff" }
  expose(:owner) { person.type.downcase }
  expose(:area) { owner.pluralize }

  protected
  
  def authorise_create
    authorise :create
  end
  
  def authorise_read
    authorise :read
  end
  
  def authorise_update
    authorise :update
  end
  
  def authorise_destroy
    authorise :destroy
  end
  
  def authorise(permission=:read)
    authorise! permission, Staff if owner == "staff" 
    authorise! permission, Patient if owner == "patient"
  end
      
  def person_id
    case
      when params[:patient_id] then params[:patient_id]
      when params[:staff_id] then params[:staff_id]
    end    
  end
end

