class PeopleController < AuthenticatedController
  respond_to :html, :json

  before_filter :add_to_recents, :except => [:search, :search_active]
  before_filter :authorise_create, :only => [:new, :create]
  before_filter :authorise_read, :only => [:recent, :show, :index, :search]
  before_filter :authorise_update, :only => [:edit, :update, :destroy]
  before_filter :authorise_destroy, :only => [:destroy]
  
  expose(:person) { Person.find_by_id(params[:id]) }
  expose(:owner) { params[:controller].singularize.downcase }
  expose(:recents) { current_user.send("#{controller_name}").secured current_user.person.security_key if current_user }
  
  expose(:active) { list_active.limit(limit).offset(skip) }
  expose(:inactive) { list_inactive.limit(limit).offset(skip) }
  expose(:active_total) { list_active.count(:all) }
  expose(:inactive_total) { list_inactive.count(:all) }
    
  def recent  
    if recents.nil? || recents.empty? 
      flash.now[:warning] = I18n.t :no_recent, :scope => "people.recent", :name => controller_name
    end
    
    respond_with recents
  end

  def show
    respond_with person
  end
  
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
  
  def authorise(permission)
    authorise! permission, Staff if owner == "staff" 
    authorise! permission, Patient if owner == "patient"
  end
  
  def add_to_recents
    if current_user && person && person.persisted?
      current_user.people << person
    end
  end
  
  def list_active
    Person.secured(current_user.person.security_key).where(:type => owner.titleize, :left_on => nil)
  end
  
  def list_inactive
    Person.secured(current_user.person.security_key).where("type = :type AND left_on IS NOT NULL", :type => owner.titleize)
  end
end