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

ActiveRecord::Schema.define(:version => 20130627151416) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "event"
    t.string   "target"
    t.string   "target_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "authorizations", :force => true do |t|
    t.integer  "user_id",      :null => false
    t.integer  "provider_id",  :null => false
    t.string   "uid",          :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "name"
    t.string   "url"
    t.string   "access_token"
  end

  add_index "authorizations", ["provider_id"], :name => "index_authorizations_on_provider_id"
  add_index "authorizations", ["uid"], :name => "index_authorizations_on_uid"
  add_index "authorizations", ["user_id", "provider_id"], :name => "index_authorizations_on_user_id_and_provider_id", :unique => true
  add_index "authorizations", ["user_id"], :name => "index_authorizations_on_user_id"

  create_table "avatars", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cities", :primary_key => "city_pk", :force => true do |t|
    t.integer  "country_pk",                                :null => false
    t.integer  "region_pk",                                 :null => false
    t.string   "name",        :limit => 45,                 :null => false
    t.text     "full_name",                 :default => "", :null => false
    t.integer  "users_count",               :default => 0,  :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "cities", ["country_pk"], :name => "index_cities_on_country_pk"
  add_index "cities", ["created_at"], :name => "index_cities_on_created_at"
  add_index "cities", ["name"], :name => "index_cities_on_name"
  add_index "cities", ["region_pk"], :name => "index_cities_on_region_pk"
  add_index "cities", ["updated_at"], :name => "index_cities_on_updated_at"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "picture_id"
    t.text     "body"
    t.boolean  "like"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "discussion_id"
  end

  create_table "countries", :primary_key => "country_pk", :force => true do |t|
    t.string   "name",                 :limit => 50,                :null => false
    t.string   "fips104",              :limit => 2,                 :null => false
    t.string   "iso2",                 :limit => 2,                 :null => false
    t.string   "iso3",                 :limit => 3,                 :null => false
    t.string   "ison",                 :limit => 4,                 :null => false
    t.string   "internet",             :limit => 2,                 :null => false
    t.string   "capital",              :limit => 25
    t.string   "map_reference",        :limit => 50
    t.string   "nationality_singular", :limit => 35
    t.string   "nationaiity_plural",   :limit => 35
    t.string   "currency",             :limit => 30
    t.string   "currency_code",        :limit => 3
    t.integer  "population"
    t.string   "title",                :limit => 50
    t.string   "comment"
    t.integer  "users_count",                        :default => 0, :null => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "countries", ["created_at"], :name => "index_countries_on_created_at"
  add_index "countries", ["currency_code"], :name => "index_countries_on_currency_code"
  add_index "countries", ["fips104"], :name => "index_countries_on_fips104"
  add_index "countries", ["internet"], :name => "index_countries_on_internet"
  add_index "countries", ["iso2"], :name => "index_countries_on_iso2"
  add_index "countries", ["iso3"], :name => "index_countries_on_iso3"
  add_index "countries", ["ison"], :name => "index_countries_on_ison"
  add_index "countries", ["name"], :name => "index_countries_on_name"
  add_index "countries", ["population"], :name => "index_countries_on_population"
  add_index "countries", ["updated_at"], :name => "index_countries_on_updated_at"
  add_index "countries", ["users_count"], :name => "index_countries_on_users_count"

  create_table "discussion_followers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "discussion_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "discussions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.datetime "last_activity_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "place"
    t.text     "address"
    t.text     "contact"
    t.string   "cost"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.datetime "started_at"
    t.datetime "ended_at"
  end

  create_table "flags", :force => true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.boolean  "innapropriate"
    t.boolean  "off_topic"
    t.boolean  "offensive"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "accepted_at"
  end

  create_table "goals", :force => true do |t|
    t.string  "name"
    t.boolean "state"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "tag"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "ettiquette"
  end

  create_table "interests", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "member_type", :default => "member"
    t.string   "status",      :default => ""
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "messages", :force => true do |t|
    t.integer  "user_id",      :null => false
    t.integer  "recipient_id"
    t.text     "body"
    t.datetime "read_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "parents", :primary_key => "parent_pk", :force => true do |t|
    t.string   "name"
    t.integer  "age"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pictures", :force => true do |t|
    t.integer  "user_id",                                      :null => false
    t.string   "title"
    t.string   "avatar1_file_name"
    t.string   "avatar1_content_type"
    t.integer  "avatar1_file_size"
    t.datetime "avatar1_updated_at"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "caption"
    t.string   "permission",           :default => "everyone", :null => false
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id",             :null => false
    t.integer  "city_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.date     "birthday"
    t.string   "relationship_status"
    t.string   "goal"
    t.text     "about_me"
    t.string   "place"
    t.string   "gender"
  end

  add_index "profiles", ["city_id"], :name => "index_profiles_on_city_id", :unique => true
  add_index "profiles", ["created_at"], :name => "index_profiles_on_created_at"
  add_index "profiles", ["updated_at"], :name => "index_profiles_on_updated_at"
  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id", :unique => true

  create_table "regions", :primary_key => "region_pk", :force => true do |t|
    t.integer  "country_pk",                               :null => false
    t.string   "name",        :limit => 45,                :null => false
    t.string   "code",        :limit => 8,                 :null => false
    t.string   "adm1code",    :limit => 4,                 :null => false
    t.integer  "users_count",               :default => 0, :null => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "regions", ["adm1code"], :name => "index_regions_on_adm1code"
  add_index "regions", ["code"], :name => "index_regions_on_code"
  add_index "regions", ["country_pk"], :name => "index_regions_on_country_pk"
  add_index "regions", ["created_at"], :name => "index_regions_on_created_at"
  add_index "regions", ["name"], :name => "index_regions_on_name"
  add_index "regions", ["updated_at"], :name => "index_regions_on_updated_at"
  add_index "regions", ["users_count"], :name => "index_regions_on_users_count"

  create_table "settings", :force => true do |t|
    t.integer  "group_id"
    t.boolean  "auto_removed"
    t.integer  "flag_count"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "update_statuses", :force => true do |t|
    t.integer  "user_id"
    t.text     "context"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.string   "related_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "user_interests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "interest_id"
    t.string   "related_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "name",                   :limit => 200, :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  add_foreign_key "authorizations", "users", :name => "authorizations_user_id_fk", :dependent => :delete

  add_foreign_key "profiles", "users", :name => "profiles_user_id_fk", :dependent => :delete

end
