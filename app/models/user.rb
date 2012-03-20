class User < ActiveRecord::Base
  belongs_to :person, :dependent => :destroy
  has_many :recents
  has_many :people, :through => :recents, :uniq => true
  has_many :memberships
  has_many :roles, :through => :memberships
  has_many :permissions, :through => :roles
  
  before_save :encrypt_password
  
  attr_accessor :password
  attr_accessible :email, :username, 
    :password, :password_confirmation, :remember_me, 
    :person, :code, :role_ids, :is_support
    
  # Validation
  validates_uniqueness_of :username, :scope => :code, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 7, :on => :create
  validates_presence_of :password, :on => :create
  validates_presence_of :username, :on => :create
  validates_email :email
  
  # Finders
  def self.find_by_username_or_email_for_code(code, identifier)
    where("(email = :identifier OR username = :identifier) AND code = :code", 
      :identifier => identifier, :code => code)
    .first 
  end
  
  def staff(limit=6)
    people.where(:type => "Staff").limit limit
  end

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.hashed_password = BCrypt::Engine.hash_secret(password, salt)
    end
  end
  
  def change_password(existing, password)
    if self.hashed_password == BCrypt::Engine.hash_secret(existing, self.salt) 
      reset_password password
    else
      false
    end
  end
  
  def reset_password(password)
    self.salt = BCrypt::Engine.generate_salt
    self.hashed_password = BCrypt::Engine.hash_secret(password, self.salt)
    self.force_password_change = false
    self.save
  end
  
  def generate(person)
    self.username = (person.first_name + person.last_name).downcase.gsub(/ /, '')
    self.password = self.password_confirmation = "password"
    self.code = person.group.code
  end
  
  def unlock
    self.is_locked = false
    self.failed_attempts = 0
    self.save
  end
  
  def lock
    self.is_locked = true
    self.save
  end

  def self.authenticate(code, identifier, password)
    user = find_by_username_or_email_for_code(code, identifier.downcase)
    
    # Set default password if necessary
    if user && user.salt.empty?
      password = user.username
      user.password = password
      user.password_confirmation = password
      user.save!
    end
    
    if user && (user.is_locked || false) == false
      if user.hashed_password == BCrypt::Engine.hash_secret(password, user.salt)
        user.failed_attempts = 0   
        user.save
          
        user
      else
        user.failed_attempts = (user.failed_attempts || 0) + 1
        user.is_locked = true if user.failed_attempts == 3
        user.save
        
        nil
      end
    else
      nil
    end
  end
end
# == Schema Information
#
# Table name: users
#
#  id                    :integer         not null, primary key
#  username              :string(32)      not null
#  email                 :string(128)     not null
#  hashed_password       :string(128)     not null
#  salt                  :string(128)     not null
#  code                  :string(6)       not null
#  person_id             :integer         not null
#  created_at            :datetime
#  updated_at            :datetime
#  legacy_id             :string(36)
#  force_password_change :boolean
#  is_locked             :boolean
#  failed_attempts       :integer         default(0)
#  ip                    :string(16)
#  last_sign_on          :datetime
#  is_support            :boolean         default(FALSE), not null
#

