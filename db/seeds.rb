require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

group = Group.create!(
  :name => 'System',
  :code => '380800', 
  :is_primary => true,
  :security_key => 0..999999999,
  :level => 1)

system = Staff.create!(
  :started_on => Date.today,
  :first_name => 'System', 
  :last_name => 'Administrator',
  :security_key => group.security_key, 
  :group => group)

admin = group.roles.create(:name => 'Administrator')

admin.permissions.create(:resource => 'staff', :action => 'full_control')
admin.permissions.create(:resource => 'group', :action => 'full_control')
admin.permissions.create(:resource => 'user', :action => 'full_control')
        
system_user = User.create!(
  :username => 'system', 
  :email => 'system@perceptal.co.uk', 
  :password => 'password', 
  :password_confirmation => 'password',
  :person => system,
  :code => group.code, 
  :is_support => true)

johnny = Staff.create!(
  :security_key => group.security_key, 
  :group => group,
  :nino => 'NW804148B',
  :started_on => Date.today,
  :first_name => 'Johnny', 
  :last_name => 'Hall', 
  :gender => 'Male', 
  :marital_status => 'Married', 
  :title => 'Mr')

User.create!(
  :username => 'johnny', 
  :code => group.code, 
  :email => 'johnny@perceptal.co.uk', 
  :password => 'password', 
  :password_confirmation => 'password',
  :person => johnny, 
  :is_support => true).roles << admin

# Demo
demo = group.children.build(:name => 'Demo', :code => '999999')
demo.setup_as_organisation
demo.save!

# Archive
archive = group.children.build(:name => 'Archive', :code => '666666')
archive.setup_as_organisation
archive.save!

nevis = demo.children.build(:name => 'Nevis')
nevis.setup_as_location
nevis.save!

braeriach = demo.children.build(:name => 'Braeriach')
braeriach.setup_as_location
braeriach.save!

lomond = demo.children.build(:name => 'Lomond')
lomond.setup_as_location
lomond.save!

manager = demo.roles.create(:name => 'Manager')
associate = demo.roles.create(:name => 'Associate')

manager.permissions.create(:resource => 'staff', :action => 'full_control')
manager.permissions.create(:resource => 'group', :action => 'editor')
manager.permissions.create(:resource => 'user', :action => 'full_control')
associate.permissions.create(:resource => 'staff', :action => 'editor')
associate.permissions.create(:resource => 'group', :action => 'read_only')
associate.permissions.create(:resource => 'user', :action => 'full_control')

# Staff
george = Staff.create!(
  :security_key => demo.security_key, 
  :group => demo,
  :started_on => Date.today,
  :first_name => 'George', 
  :last_name => 'Clooney', 
  :gender => 'Male', 
  :marital_status => 'Single',
  :dob => Date.civil(1961, 5, 6), 
  :title => 'Mr')
  
george.photos.create(:is_default => true, :image => File.open('db/photos/george.jpg'))

User.create!(
  :username => 'george', 
  :code => demo.code, 
  :email => 'george@demo.com', 
  :password => 'password', 
  :password_confirmation => 'password',
  :person => george).roles << manager

julia = Staff.create!(
  :security_key => demo.security_key, 
  :group => demo,
  :started_on => Date.today,
  :first_name => 'Julia', 
  :last_name => 'Roberts', 
  :gender => 'Female', 
  :marital_status => 'Married',
  :dob => Date.civil(1967, 10, 28), 
  :title => 'Mrs')

julia.photos.create(:is_default => true, :image => File.open('db/photos/julia.jpg'))

User.create!(
  :username => 'julia', 
  :code => demo.code, 
  :email => 'julia@demo.com', 
  :password => 'password', 
  :password_confirmation => 'password',
  :person => julia).roles << manager

tom = Staff.create!(
  :security_key => nevis.security_key, 
  :group => nevis,
  :started_on => Date.today,
  :first_name => 'Tom', 
  :last_name => 'Hanks', 
  :gender => 'Male', 
  :marital_status => 'Married',
  :dob => Date.civil(1956, 7, 9), 
  :title => 'Mr')

tom.photos.create(:is_default => true, :image => File.open('db/photos/tom.jpg'))

User.create!(
  :username => 'tom', 
  :code => demo.code, 
  :email => 'tom@demo.com', 
  :password => 'password', 
  :password_confirmation => 'password',
  :person => tom).roles << associate

angelina = Staff.create!(
  :security_key => nevis.security_key, 
  :group => nevis,
  :started_on => Date.today,
  :first_name => 'Angelina', 
  :last_name => 'Jolie', 
  :gender => 'Female', 
  :marital_status => 'Married',
  :dob => Date.civil(1975, 6, 4), 
  :title => 'Mrs')

angelina.photos.create(:is_default => true, :image => File.open('db/photos/angelina.jpg'))

User.create!(
  :username => 'angelina', 
  :code => demo.code, 
  :email => 'angelina@demo.com', 
  :password => 'password', 
  :password_confirmation => 'password',
  :person => angelina).roles << associate

brad = Staff.create!(
  :security_key => braeriach.security_key, 
  :group => braeriach,
  :started_on => Date.today,
  :first_name => 'Brad', 
  :last_name => 'Pitt', 
  :gender => 'Male', 
  :marital_status => 'Married',
  :dob => Date.civil(1963, 12, 18), 
  :title => 'Mr')

brad.photos.create(:is_default => true, :image => File.open('db/photos/brad.jpg'))

User.create!(
  :username => 'brad', 
  :code => demo.code, 
  :email => 'brad@demo.com', 
  :password => 'password', 
  :password_confirmation => 'password',
  :person => brad).roles << associate

cate = Staff.create!(
  :security_key => braeriach.security_key, 
  :group => braeriach,
  :started_on => Date.today,
  :first_name => 'Cate', 
  :last_name => 'Blanchett', 
  :gender => 'Female', 
  :marital_status => 'Married',
  :dob => Date.civil(1969, 5, 14), 
  :title => 'Ms')

cate.photos.create(:is_default => true, :image => File.open('db/photos/cate.jpg'))

User.create!(
  :username => 'cate', 
  :code => demo.code, 
  :email => 'cate@demo.com', 
  :password => 'password', 
  :password_confirmation => 'password',
  :person => cate).roles << associate

bill = Staff.create!(
  :security_key => lomond.security_key, 
  :group => lomond,
  :started_on => Date.today,
  :first_name => 'Bill', 
  :last_name => 'Murray', 
  :gender => 'Male', 
  :marital_status => 'Married',
  :dob => Date.civil(1950, 9, 21), 
  :title => 'Mr')

bill.photos.create(:is_default => true, :image => File.open('db/photos/bill.jpg'))

User.create!(
  :username => 'bill', 
  :code => demo.code, 
  :email => 'bill@demo.com', 
  :password => 'password', 
  :password_confirmation => 'password',
  :person => bill).roles << associate

kate = Staff.create!(
  :security_key => lomond.security_key, 
  :group => lomond,
  :started_on => Date.today,
  :first_name => 'Kate', 
  :last_name => 'Winslet', 
  :gender => 'Female', 
  :marital_status => 'Separated',
  :dob => Date.civil(1975, 10, 5), 
  :title => 'Ms')

kate.photos.create(:is_default => true, :image => File.open('db/photos/kate.jpg'))

User.create!(
  :username => 'kate', 
  :code => demo.code, 
  :email => 'kate@demo.com', 
  :password => 'password', 
  :password_confirmation => 'password',
  :person => kate).roles << associate





