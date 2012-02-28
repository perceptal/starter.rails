module ApplicationHelper
  def jasminerice?
    false
  end
  
  def title(name)    
    base_title = I18n.t :title

    name = I18n.t name, :scope => "#{controller_name}.#{action_name}" if !name.nil? && name.is_a?(Symbol)

    title = name.nil? ? base_title : "#{name} | #{base_title}"
    
    content_for(:title) { raw title }
    content_tag("h1", raw(name + " &rarr;"))
  end
  
  def area_name
    if defined? area
      return area if !area.nil? 
    end
    controller_name
  end
    
  def mailto(email)
    "mailto:#{email}"
  end
  
  def spacer
    raw "&nbsp;"
  end
  
  def response_time
    raw I18n.t :response, :time => sprintf('%0.02f', Time.now-@start_time)
  end
  
  def date_descriptor(date, time)
    descriptor = time.strftime("%H:%M")
    
    yesterday = Date.today-1
    today = Date.today
    tomorrow = Date.today+1
    
    descriptor += " today" if date == today
    descriptor += " yesterday" if date == yesterday
    descriptor += " tomorrow" if date == tomorrow
    descriptor += date.strftime(" on %d/%m") if date != today && date != yesterday && date != tomorrow
    
    descriptor = raw "<em>#{descriptor}</em>" if (date < today)
    
    descriptor
  end
  
  def time_descriptor(date, time)
    date = Time.new(date.year, date.month, date.day, time.hour, time.min)
    
    descriptor = distance_of_time_in_words_to_now(date)
    
    descriptor = "due #{descriptor} ago" if date <= Time.now
    descriptor = "due in #{descriptor}" if date > Time.now
    
    descriptor
  end
end
