class AddAddressColumns < ActiveRecord::Migration
  def change
    add_column :people, :address_line_1, :string, :limit => 64
    add_column :people, :address_line_2, :string, :limit => 64
    add_column :people, :address_locality, :string, :limit => 64
    add_column :people, :address_area, :string, :limit => 64
    add_column :people, :address_country, :string, :limit => 64
    add_column :people, :address_postcode, :string, :limit => 10
    add_column :groups, :address_line_1, :string, :limit => 64
    add_column :groups, :address_line_2, :string, :limit => 64
    add_column :groups, :address_locality, :string, :limit => 64
    add_column :groups, :address_area, :string, :limit => 64
    add_column :groups, :address_country, :string, :limit => 64
    add_column :groups, :address_postcode, :string, :limit => 10
  end
end
