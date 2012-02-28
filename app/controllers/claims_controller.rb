class ClaimsController < AnonymousController
  respond_to :html, :json
  
  expose(:claims)
  
  def index
    respond_with claims
  end
end
