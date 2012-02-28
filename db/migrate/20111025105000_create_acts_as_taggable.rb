class CreateActsAsTaggable < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.column :name, :string, :limit => 128
    end
    
    create_table :taggings do |t|
      t.column :tag_id, :integer
      t.column :taggable_id, :integer
      t.column :tagger_id, :integer
      t.column :tagger_type, :string, :limit => 128
      
      # You should make sure that the column created is
      # long enough to store the required class names.
      t.column :taggable_type, :string, :limit => 128
      t.column :context, :string, :limit => 128
      
      t.column :created_at, :datetime
    end
    
    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type, :context]
  end
end