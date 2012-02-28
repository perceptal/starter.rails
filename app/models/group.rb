class Group < ActiveRecord::Base
  include Securable, Addressable
  
  has_many :people
  has_many :staff
  has_many :children, :class_name => "Group", :foreign_key => "parent_id"
  has_many :roles, :include => :permissions
  belongs_to :parent, :class_name => "Group"
  
  attr_accessible :name, :code, :is_primary, :level
    
  # Validations
  validates_presence_of :name, :code, :level
  validates_length_of :code, :in => 6..6

  scope :secured, lambda { |key| where("low_security_key >= ? and high_security_key <= ?", key.min, key.max).order("name") }

  def setup_as_organisation
    self.parent = Group.find_by_parent_id nil
    self.is_primary = true
    self.level = self.parent.level + 1
    self.security_key = determine_security_key
  end
  
  def setup_as_location
    self.code = self.parent.code
    self.level = self.parent.level + 1
    self.security_key = determine_security_key
  end

  private
  
  def determine_security_key
    parent_key = self.parent.security_key
    range = (parent_key.max / level_numbers[self.level - 1]).to_i
    count = self.parent.children.count
    
    ((count * range) + parent_key.min)..(((count+1) * range) + parent_key.min-1)
  end
  
  def level_numbers
    [1, 1000, 100]
  end
end
# == Schema Information
#
# Table name: groups
#
#  id                :integer         not null, primary key
#  name              :string(32)      not null
#  code              :string(6)       not null
#  low_security_key  :integer         not null
#  high_security_key :integer         not null
#  level             :integer         not null
#  is_primary        :boolean         default(FALSE)
#  parent_id         :integer
#  created_at        :datetime
#  updated_at        :datetime
#  address_line_1    :string(64)
#  address_line_2    :string(64)
#  address_locality  :string(64)
#  address_area      :string(64)
#  address_country   :string(64)
#  address_postcode  :string(10)
#  legacy_id         :string(36)
#

