class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name, :null => false, :limit => 32
      t.string :last_name, :null => false, :limit => 32
      t.string :known_as, :limit => 32
      t.string :gender, :limit => 8
      t.string :marital_status, :limit => 16
      t.string :title, :limit => 16
      t.string :uri, :limit => 128
      t.date :dob
      t.integer :low_security_key, :null => false
      t.integer :high_security_key, :null => false
      t.references :group, :null => false
      t.date :left_on
      
      t.timestamps
    end
    
    add_index :people, [:low_security_key, :high_security_key]
  end
end
