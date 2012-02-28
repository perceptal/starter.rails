class CreateRecents < ActiveRecord::Migration
  def change
    create_table :recents do |t|
      t.references :user, :null => false
      t.references :person, :null => false
      
      t.timestamps
    end
    
    add_index :recents, [:user_id, :person_id]
  end
end
