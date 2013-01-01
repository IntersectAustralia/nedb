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

ActiveRecord::Schema.define(:version => 20120710063834) do

  create_table "botanical_divisions", :force => true do |t|
    t.integer  "state_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "confirmations", :force => true do |t|
    t.integer  "specimen_id"
    t.integer  "confirmer_id"
    t.integer  "confirmer_herbarium_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "confirmation_date_year"
    t.integer  "confirmation_date_month"
    t.integer  "confirmation_date_day"
    t.integer  "determination_id"
    t.boolean  "legacy"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "determination_determiners", :id => false, :force => true do |t|
    t.integer "determination_id"
    t.integer "determiner_id"
  end

  add_index "determination_determiners", ["determination_id"], :name => "index_determination_determiners_on_determination_id"
  add_index "determination_determiners", ["determiner_id"], :name => "index_determination_determiners_on_determiner_id"

  create_table "determinations", :force => true do |t|
    t.integer  "specimen_id"
    t.string   "division"
    t.string   "family"
    t.string   "genus"
    t.string   "species"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "determiner_herbarium_id"
    t.string   "class_name"
    t.string   "sub_family"
    t.string   "species_authority"
    t.string   "sub_species"
    t.string   "sub_species_authority"
    t.string   "variety"
    t.string   "variety_authority"
    t.string   "form"
    t.string   "form_authority"
    t.integer  "determination_date_year"
    t.integer  "determination_date_month"
    t.integer  "determination_date_day"
    t.string   "order_name"
    t.string   "tribe"
    t.string   "species_uncertainty"
    t.string   "subspecies_uncertainty"
    t.string   "variety_uncertainty"
    t.string   "form_uncertainty"
    t.string   "family_uncertainty"
    t.string   "sub_family_uncertainty"
    t.string   "tribe_uncertainty"
    t.string   "genus_uncertainty"
    t.boolean  "naturalised"
    t.boolean  "legacy"
  end

  create_table "forms", :force => true do |t|
    t.string   "form"
    t.string   "authority"
    t.integer  "species_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "herbaria", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "create_labels"
  end

  create_table "items", :force => true do |t|
    t.integer  "specimen_id"
    t.integer  "item_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.integer  "herbarium_id"
    t.integer  "date_of_birth_day"
    t.integer  "date_of_birth_month"
    t.integer  "date_of_birth_year"
    t.integer  "date_of_death_day"
    t.integer  "date_of_death_month"
    t.integer  "date_of_death_year"
    t.string   "address"
    t.string   "email"
    t.string   "initials"
  end

  create_table "permissions", :force => true do |t|
    t.string   "entity"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles_permissions", :id => false, :force => true do |t|
    t.integer "profile_id"
    t.integer "permission_id"
  end

  add_index "profiles_permissions", ["permission_id"], :name => "index_profiles_permissions_on_permission_id"
  add_index "profiles_permissions", ["profile_id"], :name => "index_profiles_permissions_on_profile_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "species", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "division"
    t.string   "class_name"
    t.string   "order_name"
    t.string   "family"
    t.string   "sub_family"
    t.string   "tribe"
    t.string   "genus"
    t.string   "authority"
  end

  create_table "specimen_images", :force => true do |t|
    t.integer  "specimen_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "specimen_replicates", :id => false, :force => true do |t|
    t.integer "specimen_id"
    t.integer "herbarium_id"
  end

  add_index "specimen_replicates", ["herbarium_id"], :name => "index_specimen_replicates_on_herbarium_id"
  add_index "specimen_replicates", ["specimen_id"], :name => "index_specimen_replicates_on_specimen_id"

  create_table "specimen_secondary_collectors", :id => false, :force => true do |t|
    t.integer "specimen_id"
    t.integer "collector_id"
  end

  add_index "specimen_secondary_collectors", ["collector_id"], :name => "index_specimen_secondary_collectors_on_collector_id"
  add_index "specimen_secondary_collectors", ["specimen_id"], :name => "index_specimen_secondary_collectors_on_specimen_id"

  create_table "specimens", :force => true do |t|
    t.integer  "collector_id"
    t.string   "collector_number"
    t.string   "country"
    t.string   "state"
    t.string   "botanical_division"
    t.text     "locality_description"
    t.integer  "latitude_degrees"
    t.integer  "latitude_minutes"
    t.integer  "longitude_degrees"
    t.integer  "longitude_minutes"
    t.integer  "altitude"
    t.string   "point_data"
    t.string   "datum"
    t.text     "topography"
    t.string   "aspect"
    t.text     "substrate"
    t.text     "vegetation"
    t.string   "frequency"
    t.text     "plant_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "latitude_hemisphere",   :limit => 1
    t.string   "longitude_hemisphere",  :limit => 1
    t.integer  "collection_date_year"
    t.integer  "collection_date_month"
    t.integer  "collection_date_day"
    t.decimal  "latitude_seconds"
    t.decimal  "longitude_seconds"
    t.string   "status"
    t.boolean  "needs_review",                       :default => false
    t.string   "replicate_from"
    t.string   "replicate_from_no"
    t.boolean  "legacy"
  end

  create_table "states", :force => true do |t|
    t.integer  "country_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subspecies", :force => true do |t|
    t.string   "subspecies"
    t.string   "authority"
    t.integer  "species_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uncertainty_types", :force => true do |t|
    t.string   "uncertainty_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                   :default => "",  :null => false
    t.string   "encrypted_password",       :limit => 128, :default => "",  :null => false
    t.string   "password_salt",                           :default => "",  :null => false
    t.string   "reset_password_token"
    t.integer  "sign_in_count",                           :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "other_initials"
    t.string   "position"
    t.string   "supervisor"
    t.text     "address"
    t.string   "telephone"
    t.string   "group_school_institution"
    t.string   "status",                                  :default => "U"
    t.integer  "profile_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "varieties", :force => true do |t|
    t.string   "variety"
    t.string   "authority"
    t.integer  "species_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
