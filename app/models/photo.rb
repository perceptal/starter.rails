class Photo < ActiveRecord::Base
  scope :is_default, where(:is_default => true)
  
  belongs_to :person

  attr_accessible :caption, :is_default, :image
  
  has_attached_file :image, 
    :styles => { :thumbnail => "50x50#", :small => "175x175>", :large => "600x600>" },
    :storage => :s3,
    #:s3_permissions => :private,
    :path => ":attachment/:style/:id.:extension",
    :s3_credentials => {
      :access_key_id => Starter::Application.config.s3_key,
      :secret_access_key => Starter::Application.config.s3_secret
    },
    :bucket => Starter::Application.config.s3_bucket
  
  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 5.megabytes
end
# == Schema Information
#
# Table name: photos
#
#  id                 :integer         not null, primary key
#  caption            :string(128)
#  is_default         :boolean
#  person_id          :integer
#  image_file_name    :string(128)
#  image_content_type :string(32)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  created_at         :datetime
#  updated_at         :datetime
#

