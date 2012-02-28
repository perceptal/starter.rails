class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, :null => false, :limit => 32
      t.string :code, :null => false, :limit => 6
      t.integer :low_security_key, :null => false
      t.integer :high_security_key, :null => false
      t.integer :level, :null => false
      t.boolean :is_primary, :default => false
      t.references :parent
      
      t.timestamps
    end
    
    add_index :groups, :name, :unique => true
    add_index :groups, [:low_security_key, :high_security_key]
  end
end
