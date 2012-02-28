class Permission < ActiveRecord::Base
  scope :by_resource, lambda { |r| where(:resource => r) }

  belongs_to :role

  attr_accessible :action, :resource, :resource_id

  def self.resources
    %w[Staff Patient Group User]
  end
  
  def self.permissions
    [["No Access", :no_access], ["Read Only", :read_only], ["Editor", :editor], ["Full Control", :full_control]]
  end  
end
# == Schema Information
#
# Table name: permissions
#
#  id          :integer         not null, primary key
#  action      :string(255)
#  resource    :string(255)
#  resource_id :integer
#  role_id     :integer         not null
#  created_at  :datetime
#  updated_at  :datetime
#

