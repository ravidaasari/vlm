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

ActiveRecord::Schema.define(version: 2018_07_24_113359) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "catalogs", force: :cascade do |t|
    t.string "catalog_name"
    t.integer "cpu_min"
    t.integer "cpu_max"
    t.integer "mem_min"
    t.integer "mem_max"
    t.integer "disk_size"
    t.boolean "swap_disk"
    t.string "template_path"
    t.string "template_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "provider_id"
  end

  create_table "infobloxes", force: :cascade do |t|
    t.string "infoblox_url"
    t.string "infoblox_username"
    t.string "encrypted_infoblox_password"
    t.string "encrypted_infoblox_password_iv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "providers", force: :cascade do |t|
    t.string "provider_name"
    t.string "provider_type"
    t.string "provider_url"
    t.string "provider_user"
    t.string "provider_session"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_provider_password"
    t.string "encrypted_provider_password_iv"
  end

  create_table "users", force: :cascade do |t|
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username"
  end

end
