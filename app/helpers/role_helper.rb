module RoleHelper
  def role_label(role)
    content_tag :span, role.name, :class => "text"
  end
end