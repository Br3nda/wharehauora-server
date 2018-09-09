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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180905092840) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "gateways", id: :serial, force: :cascade do |t|
    t.text "mac_address"
    t.text "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "home_types", id: :serial, force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "home_viewers", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "home_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "home_id"], name: "index_home_viewers_on_user_id_and_home_id", unique: true
  end

  create_table "homes", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "name", null: false
    t.integer "owner_id", null: false
    t.boolean "is_public", default: false, null: false
    t.integer "home_type_id"
    t.integer "rooms_count"
    t.integer "sensors_count"
    t.string "gateway_mac_address"
    t.index ["is_public"], name: "index_homes_on_is_public"
    t.index ["name"], name: "index_homes_on_name"
    t.index ["owner_id"], name: "index_homes_on_owner_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.integer "node_id"
    t.string "message_type"
    t.integer "child_sensor_id"
    t.integer "ack"
    t.integer "sub_type"
    t.text "payload"
    t.integer "sensor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "topic"
    t.index ["created_at"], name: "index_messages_on_created_at"
    t.index ["sensor_id"], name: "index_messages_on_sensor_id"
  end

  create_table "mqtt_users", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "username"
    t.string "password"
    t.datetime "provisioned_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "home_id"
  end

  create_table "oauth_access_grants", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "old_readings", id: :serial, force: :cascade do |t|
    t.integer "sensor_id"
    t.text "key"
    t.float "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message_type"
    t.integer "child_sensor_id"
    t.integer "ack"
    t.integer "sub_type"
  end

  create_table "readings", id: :serial, force: :cascade do |t|
    t.integer "room_id", null: false
    t.text "key", null: false
    t.float "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_readings_on_created_at"
    t.index ["key", "room_id"], name: "index_readings_on_key_and_room_id"
    t.index ["key"], name: "index_readings_on_key"
    t.index ["room_id"], name: "index_readings_on_room_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "friendly_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "room_types", id: :serial, force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "min_temperature"
    t.float "max_temperature"
  end

  create_table "rooms", id: :serial, force: :cascade do |t|
    t.integer "home_id", null: false
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "room_type_id"
    t.integer "readings_count"
    t.integer "sensors_count", default: 0
    t.index ["home_id"], name: "index_rooms_on_home_id"
    t.index ["name"], name: "index_rooms_on_name"
  end

  create_table "sensors", id: :serial, force: :cascade do |t|
    t.integer "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "node_id", null: false
    t.integer "home_id", null: false
    t.integer "messages_count"
    t.string "mac_address"
    t.index ["node_id"], name: "index_sensors_on_node_id"
  end

  create_table "user_roles", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.integer "invitations_count", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "home_viewers", "homes"
  add_foreign_key "home_viewers", "users"
  add_foreign_key "homes", "home_types"
  add_foreign_key "homes", "users", column: "owner_id"
  add_foreign_key "messages", "sensors"
  add_foreign_key "mqtt_users", "homes"
  add_foreign_key "mqtt_users", "users"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "readings", "rooms"
  add_foreign_key "rooms", "room_types"
  add_foreign_key "sensors", "homes"
  add_foreign_key "sensors", "rooms"
end
