module MenuHelper
  def link(name, path, resource=nil, permission=:read, controller=controller_name, action="index", method="get", disabled=false)
    if resource.nil? || can?(permission, resource)
      build_link(name, path, controller, action, method, disabled)
    end
  end
  
  def menu(name, path, resource=nil, permission=:read, controller=controller_name, action="index", method="get", disabled=false)   
    if resource.nil? || can?(permission, resource)
      content_tag(:li, build_link(name, path, controller, action, method, disabled), :class => controller)
    end
  end
  
  def button(name, message=nil)
    text = I18n.t(name, :scope => "#{controller_name}.#{action_name}", :default => I18n.t(:save))
    text = raw(text + " &rarr;")
    message = I18n.t(message, :scope => "#{controller_name}.#{action_name}", :default => I18n.t(:saving)) if !message.nil?

    submit_tag text, "data-submit-message" => message
  end
  
  def submit(f, name, resource=nil, permission=:update, message=nil)
    text = I18n.t(name, :scope => "#{controller_name}.#{action_name}", :default => I18n.t(:save))
    text = raw(text + " &rarr;")
    message = I18n.t(message, :scope => "#{controller_name}.#{action_name}", :default => I18n.t(:saving)) if !message.nil?
    
    if resource.nil? || can?(permission, resource)
      f.submit text, "data-submit-message" => message
    else
      f.submit text, :disabled => true
    end
	end
  
  private
  
  def build_link(name, path, controller, action, method, disabled)
    path = "javascript:void(0);" if disabled
    
    text = I18n.t name, :scope => "navigation"
    
    if method == "get"
      link_to(raw(text), path, :class => get_class(controller, action, disabled) + " #{action}")
    else
      link = link_to(raw(text), path, :class => get_class(controller, action, disabled) + " #{action}", :data => { :method => method })
    end
  end

  def get_class(controller, action, disabled)
    if controller == false
      disabled ? "disabled" : ""
    else
      if includes_controller?(controller) && includes_action?(action)
        disabled ? "disabled" : "active"
      else
        disabled ? "disabled" : ""
      end
    end
  end

  def includes_controller?(controller)
    return controller.split(',').include? controller_name
  end

  def includes_action?(action)
    template = @template_name

    if template.is_a?(Hash) && template.has_key?(:template)
      template = template[:template]
    end

    if template.nil? || template.empty?
      template = action_name
    end

    if template.include? "/"
      parts = template.split('/')
      template = parts[parts.length-1]
    end
    
    return action.split(',').include? template
  end
end
