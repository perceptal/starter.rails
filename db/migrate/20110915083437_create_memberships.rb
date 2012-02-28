class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :role, :null => false
      t.references :user, :null => false
      
      t.timestamps
    end
    
    add_index :memberships, [:user_id, :role_id]
  end
end
