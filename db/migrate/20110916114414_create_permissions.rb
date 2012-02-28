class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :action
      t.string :resource
      t.integer :resource_id
      t.references :role, :null => false
      
      t.timestamps
    end
    
    add_index :permissions, :role_id
  end
end
