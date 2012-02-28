class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :caption, :limit => 128
      t.boolean :is_default
      t.references :person
      t.string :image_file_name, :limit => 128
      t.string :image_content_type, :limit => 32
      t.integer :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end
  end
end
