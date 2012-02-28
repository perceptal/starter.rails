# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111025105000) do

  create_table "groups", :force => true do |t|
    t.string   "name",              :limit => 32,                    :null => false
    t.string   "code",              :limit => 6,                     :null => false
    t.integer  "low_security_key",                                   :null => false
    t.integer  "high_security_key",                                  :null => false
    t.integer  "level",                                              :null => false
    t.boolean  "is_primary",                      :default => false
    t.integer  "parent_id"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "address_line_1",    :limit => 64
    t.string   "address_line_2",    :limit => 64
    t.string   "address_locality",  :limit => 64
    t.string   "address_area",      :limit => 64
    t.string   "address_country",   :limit => 64
    t.string   "address_postcode",  :limit => 10
  end

  add_index "groups", ["low_security_key", "high_security_key"], :name => "index_groups_on_low_security_key_and_high_security_key"
  add_index "groups", ["name"], :name => "index_groups_on_name", :unique => true

  create_table "memberships", :force => true do |t|
    t.integer  "role_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "memberships", ["user_id", "role_id"], :name => "index_memberships_on_user_id_and_role_id"

  create_table "people", :force => true do |t|
    t.string   "first_name",         :limit => 32,  :null => false
    t.string   "last_name",          :limit => 32,  :null => false
    t.string   "known_as",           :limit => 32
    t.string   "gender",             :limit => 8
    t.string   "marital_status",     :limit => 16
    t.string   "title",              :limit => 16
    t.string   "uri",                :limit => 128
    t.date     "dob"
    t.integer  "low_security_key",                  :null => false
    t.integer  "high_security_key",                 :null => false
    t.integer  "group_id",                          :null => false
    t.date     "left_on"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "type",               :limit => 16
    t.string   "nino",               :limit => 9
    t.date     "started_on"
    t.string   "job_title",          :limit => 128
    t.string   "reason_for_leaving", :limit => 128
    t.string   "phone_home",         :limit => 14
    t.string   "phone_work",         :limit => 14
    t.string   "phone_mobile",       :limit => 14
    t.string   "phone_primary",      :limit => 6
    t.string   "address_line_1",     :limit => 64
    t.string   "address_line_2",     :limit => 64
    t.string   "address_locality",   :limit => 64
    t.string   "address_area",       :limit => 64
    t.string   "address_country",    :limit => 64
    t.string   "address_postcode",   :limit => 10
  end

  add_index "people", ["low_security_key", "high_security_key"], :name => "index_people_on_low_security_key_and_high_security_key"

  create_table "permissions", :force => true do |t|
    t.string   "action"
    t.string   "resource"
    t.integer  "resource_id"
    t.integer  "role_id",     :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "permissions", ["role_id"], :name => "index_permissions_on_role_id"

  create_table "photos", :force => true do |t|
    t.string   "caption",            :limit => 128
    t.boolean  "is_default"
    t.integer  "person_id"
    t.string   "image_file_name",    :limit => 128
    t.string   "image_content_type", :limit => 32
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "recents", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "person_id",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "recents", ["user_id", "person_id"], :name => "index_recents_on_user_id_and_person_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "roles", ["group_id"], :name => "index_roles_on_group_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type",   :limit => 128
    t.string   "taggable_type", :limit => 128
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name", :limit => 128
  end

  create_table "users", :force => true do |t|
    t.string   "username",              :limit => 32,                     :null => false
    t.string   "email",                 :limit => 128
    t.string   "hashed_password",       :limit => 128,                    :null => false
    t.string   "salt",                  :limit => 128,                    :null => false
    t.string   "code",                  :limit => 6,                      :null => false
    t.integer  "person_id",                                               :null => false
    t.boolean  "is_support",                           :default => false
    t.boolean  "force_password_change",                :default => true
    t.boolean  "is_locked",                            :default => false
    t.integer  "failed_attempts",                      :default => 0
    t.string   "ip",                    :limit => 16
    t.datetime "last_sign_on"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["person_id"], :name => "index_users_on_person_id", :unique => true
  add_index "users", ["username", "code"], :name => "index_users_on_username_and_code", :unique => true

end
