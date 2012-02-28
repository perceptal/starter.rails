class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.references :group

      t.timestamps
    end
    
    add_index :roles, :group_id
  end
end
