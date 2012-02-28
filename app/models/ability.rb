class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, :to => :full_control
    alias_action :create, :read, :update, :to => :editor
    alias_action :read, :to => :read_only
    alias_action :deny, :to => :no_access
    
    return if user.nil? || user.person.nil?
    
    if user.is_support
      can :full_control, :all
    else
      can do |action, resource, object|
        user.permissions.find_all_by_action(aliases_for_action(action)).any? do |permission|
          permission.resource.downcase == resource.to_s.downcase &&
            (object.nil? || permission.resource_id.nil? || permission.resource_id == object.id)
        end
      end
    end
  end
end