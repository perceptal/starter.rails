class Recent < ActiveRecord::Base  
  belongs_to :user
  belongs_to :person
end
# == Schema Information
#
# Table name: recents
#
#  id         :integer         not null, primary key
#  user_id    :integer         not null
#  person_id  :integer         not null
#  created_at :datetime
#  updated_at :datetime
#

