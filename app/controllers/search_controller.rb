class SearchController < AuthenticatedController
  respond_to :html, :json
    
  expose(:query) { params[:q] || "" }
  expose(:search) { params[:s] || "" }
  expose(:type) { (params[:t] || "").singularize.titleize }
  expose(:people) { Searcher.search(query, type, skip, PAGE_SIZE, current_user.person.security_key) } 
  expose(:total) { Searcher.count(query, type, current_user.person.security_key) } 
  
  def index  
    if total == 1 && request.format == :html
      redirect_to people.first.uri
    else
      build_message query, people.count, total
      
      respond_to do|format|
        format.html
        format.json do
          render :json => 
            { :page => page, :skip => skip, :limit => PAGE_SIZE, :total => total, :query => query, :results => people }
        end
      end
    end
  end
  
  private 
  
  def build_message(query, paged, total)
    if query.empty?
      flash.now.alert = t(:error)
      return
    end
    
    result = t(:results)
    count = total

    result = result.singularize if count == 1
    count = t(:no) if count == 0
    
    message = "#{count} #{result} #{t(:found)}"
    
    flash.now.notice = message if paged > 0
    flash.now[:warning] = message if paged == 0    
  end
end
