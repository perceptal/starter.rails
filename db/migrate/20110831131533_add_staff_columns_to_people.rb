class AddStaffColumnsToPeople < ActiveRecord::Migration
  def change
    add_column :people, :type, :string, :limit => 16
    add_column :people, :nino, :string, :limit => 9
    add_column :people, :started_on, :date
    add_column :people, :job_title, :string, :limit => 128
    add_column :people, :reason_for_leaving, :string, :limit => 128
    add_column :people, :phone_home, :string, :limit => 14
    add_column :people, :phone_work, :string, :limit => 14
    add_column :people, :phone_mobile, :string, :limit => 14
    add_column :people, :phone_primary, :string, :limit => 6
  end
end
