class Staff < Person
  after_create :generate_uri
    
  attr_accessible :started_on, :job_title
    
  validates_presence_of :started_on, :on => :create

  def started_on_formatted
    started_on.strftime "%d %B %Y"
  end
  
  def left_on_formatted
    left_on.strftime "%d %B %Y" if !left_on.nil?
  end
    
  def leave(reason, on)
    super reason, on
  end
  
  private
  
  def generate_uri
    self.uri = url_helpers.staff_path(self)
    save!
  end
end
# == Schema Information
#
# Table name: people
#
#  id                 :integer         not null, primary key
#  first_name         :string(32)      not null
#  last_name          :string(32)      not null
#  known_as           :string(32)
#  gender             :string(8)
#  marital_status     :string(16)
#  title              :string(16)
#  uri                :string(128)
#  dob                :date
#  low_security_key   :integer         not null
#  high_security_key  :integer         not null
#  group_id           :integer         not null
#  created_at         :datetime
#  updated_at         :datetime
#  type               :string(16)
#  nino               :string(9)
#  started_on         :date
#  left_on            :date
#  admitted_on        :date
#  carer_id           :integer
#  address_line_1     :string(64)
#  address_line_2     :string(64)
#  address_locality   :string(64)
#  address_area       :string(64)
#  address_country    :string(64)
#  address_postcode   :string(10)
#  drug_sensitivities :string(512)
#  relationship_type  :string(16)
#  is_next_of_kin     :boolean
#  person_id          :integer
#  profession         :string(32)
#  organisation       :string(64)
#  admitted_from      :string(128)
#  physical           :string(512)
#  ethnicity          :string(32)
#  religion           :string(32)
#  place_of_birth     :string(32)
#  room_id            :integer
#  legacy_id          :string(36)
#  phone_home         :string(14)
#  phone_work         :string(14)
#  phone_mobile       :string(14)
#  phone_primary      :string(6)
#  reason_for_leaving :string(128)
#  email              :string(128)
#  job_title          :string(128)
#  dnar               :boolean
#  nhs_number         :string(32)
#

