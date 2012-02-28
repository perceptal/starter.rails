class PhotosController < PeopleItemsController
  respond_to :html, :json
  
  before_filter :authorise_read, :only => [:download]
  before_filter :authorise_update, :only => [:default]

  expose(:photo)
  
  def show
    render "index"
  end
  
  def new
  end

  def index
    if person.photos.empty?
      flash.now[:warning] = t :error
    end
  end

  def create
    photo = person.photos.build(params[:photo])
    if photo.save
      person.set_profile_photo(photo)
      flash.now.notice = t :success
      render "index"
    else
      flash.now.alert = t :error
      render "new"
    end
  end
  
  def default
    person.set_profile_photo(photo)
    
    flash.now.notice = t :success
    render "index"
  end
  
  def destroy
    if photo.destroy
      person.set_profile_photo(person.photos.first) if !person.photos.empty?
      flash.now.notice = t :success
    else
      flash.now.alert = t :error
    end
    render "index"
  end
  
  def download
    redirect_to photo.image.expiring_url(10, params[:format])
  end
end
