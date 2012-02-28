class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :role

  attr_accessible :user_id, :role_id  
end
# == Schema Information
#
# Table name: memberships
#
#  id         :integer         not null, primary key
#  role_id    :integer         not null
#  user_id    :integer         not null
#  created_at :datetime
#  updated_at :datetime
#

