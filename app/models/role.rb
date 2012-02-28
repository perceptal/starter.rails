class Role < ActiveRecord::Base  
  has_many :memberships
  has_many :users, :through => :memberships
  has_many :permissions, :dependent => :destroy
  belongs_to :group
    
  attr_accessible :name, :group
  
  validates_presence_of :name, :message => "Please enter a role name"
  
  def init
    self.permissions.each { |p| p.destroy }
    self.permissions.create(:resource => 'patient', :action => 'read_only')
    self.permissions.create(:resource => 'staff', :action => 'read_only')
    self.permissions.create(:resource => 'group', :action => 'read_only')
    self.permissions.create(:resource => 'user', :action => 'full_control')
  end
  
  def update_permissions(permissions)
    self.permissions.each { |p| p.destroy }
    Permission.resources.each do |resource|
      action = permissions[resource.downcase]
      self.permissions.create(:action => action, :resource => resource.downcase) if action.to_sym != :no_access
    end
  end
end
# == Schema Information
#
# Table name: roles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  group_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

