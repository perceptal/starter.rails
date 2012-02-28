class HomeController < AnonymousController
  respond_to :html, :json
  
  def denied
    render_access_denied
  end
end
