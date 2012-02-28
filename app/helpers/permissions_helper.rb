module PermissionsHelper
  def permission_for_display(role, resource)
    permission(role, resource)[0]
  end  
  
  def permission_for(role, resource)
    permission(role, resource)[1]
  end

  private
  
  def permission(role, resource)
    all = Permission.permissions    
    permission = role.permissions.by_resource(resource.downcase).first

    if !permission.nil?
      all.detect { |a| a.include?(permission.action.to_sym) }
    else
      all.detect { |a| a.include?(:no_access) }
    end
  end
end