class Person < ActiveRecord::Base 
  include Securable, Lookup, Addressable
   
  delegate :url_helpers, to: "Rails.application.routes"

  before_validation :generate, :if => Proc.new { |p| p.new_record? } 

  belongs_to :group
  has_many :recents
  has_many :photos, :dependent => :destroy, :order => "created_at desc"
  has_one :profile_photo, :class_name => "Photo", :conditions => { :is_default => true }
  has_one :user, :dependent => :destroy
  
  scope :secured, lambda { |key| where("low_security_key >= ? and high_security_key <= ?", key.min, key.max).order("first_name, last_name") }
  
  accepts_nested_attributes_for :photos, :reject_if => lambda { |t| t["image"].nil? }
  accepts_nested_attributes_for :user
  
  attr_reader :full_name
  attr_accessible :first_name, :last_name, :gender, :marital_status, :title, :dob, :left_on,
    :owner, :group, :user_attributes, :nino, :known_as, :phone_mobile, :phone_home, :phone_work

  validates_presence_of :first_name, :last_name, :group
  validates_length_of :nino, :in => 9..9, :allow_blank => true
  validates_associated :user
  
  def join_group_of(person)
    join_group person.group
  end
  
  def join_group(group)
    self.group = group
    self.change_keys group
  end
  
  def change_keys(group)
    self.security_key = group.security_key
  end
  
  def primary_group
    parent = group
    while !parent.is_primary
      parent = parent.parent
      
      break if parent.is_primary
    end
    parent
  end
  
  def groups
    if !self.user.nil? && self.user.is_support
      Group.all
    else
      [self.primary_group].concat self.primary_group.children.entries
    end
  end
  
  def location
    Group.where(:low_security_key => self.security_key.min, :high_security_key => self.security_key.max).first
  end
    
  def full_name
    [first_name, last_name].join(' ')
  end
  
  def name_and_title
    [title, first_name, last_name].join(' ')
  end
  
  def phone
    return phone_mobile if (phone_primary == "mobile" || phone_primary.nil?) && (!phone_mobile.nil? && !phone_mobile.empty?)
    return phone_home if (phone_primary == "home" || phone_primary.nil?) && (!phone_home.nil? && !phone_home.empty?)
    return phone_work if (phone_primary == "work" || phone_primary.nil?) && (!phone_work.nil? && !phone_work.empty?)
  end
  
  def resource
    type.pluralize
  end
  
  def area
    resource
  end
  
  def profile_image_thumbnail_url
    profile_photo.image.url(:thumbnail) if !photos.is_default.empty?
  end
  
  def set_profile_photo(photo)
    if photos.many?
      photos.each do |p|
        if p != photo
          p.is_default = false
          p.save
        end
      end
    end
    photo.is_default = true
    photo.save
  end
  
  def leave(reason, on)
    self.reason_for_leaving = reason
    self.left_on = on
    self.save
  end
  
  def as_json(options={})
    super(
      :include => [:user],
      :except => [:hashed_password, :salt, :low_security_key, :high_security_key], 
      :methods => [:full_name, :type, :resource, :area, :profile_image_thumbnail_url, :phone, :admitted_on_formatted, :left_on_formatted])
      .merge(options)
  end
  
  def self.genders
    %w[Male Female]
  end
  
  def maritals
    lookup %w[Single Married Divorced Separated Widowed], self.marital_status
  end
  
  def titles
    lookup %w[Mr Mrs Miss Ms Dr], self.title
  end
  
  private
  
  def generate
    self.started_on = Date.today
    self.user.generate self if !self.user.nil?
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
#  email              :string(128)
#  reason_for_leaving :string(128)
#

