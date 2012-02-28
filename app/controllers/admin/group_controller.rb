class Admin::GroupController < AuthenticatedController
  before_filter :authorise_create, :only => [:new, :create]
  before_filter :authorise_read, :only => [:show, :index]
  before_filter :authorise_update, :only => [:edit, :update]
  before_filter :authorise_destroy, :only => [:destroy]
    
  protected

  def authorise_create
    authorise! :create, Group
  end
  
  def authorise_read
    authorise! :read, Group
  end
  
  def authorise_update
    authorise! :update, Group
  end
  
  def authorise_destroy
    authorise! :destroy, Group
  end
end