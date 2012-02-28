class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :username, :null => false, :limit => 32
      t.string :email, :limit => 128
      t.string :hashed_password, :null => false, :limit => 128
      t.string :salt, :null => false, :limit => 128
      t.string :code, :null => false, :limit => 6
      t.references :person, :null => false
      t.boolean :is_support, :default => false
      t.boolean :force_password_change, :default => true
      t.boolean :is_locked, :default => false
      t.integer :failed_attempts, :default => 0
      t.string :ip, :limit => 16
      t.datetime :last_sign_on
      
      t.timestamps
    end

    add_index :users, [:username, :code],     :unique => true
    add_index :users, :email,                 :unique => true
    add_index :users, :person_id,             :unique => true
  end
end
