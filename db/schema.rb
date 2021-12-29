# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_12_27_121531) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "role"
    t.datetime "email_confirmed_at", precision: 6
    t.datetime "terms_accepted_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "users_activities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "session_id"
    t.string "action", null: false
    t.text "metadata"
    t.datetime "created_at", precision: 6
    t.string "referrer"
    t.string "user_agent"
    t.string "ip"
    t.string "country"
    t.string "region"
    t.string "city"
    t.index ["action"], name: "index_users_activities_on_action"
    t.index ["ip"], name: "index_users_activities_on_ip"
    t.index ["session_id"], name: "index_users_activities_on_session_id"
    t.index ["user_id"], name: "index_users_activities_on_user_id"
  end

  create_table "users_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "token", null: false
    t.datetime "accessed_at", precision: 6
    t.datetime "revoked_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["accessed_at"], name: "index_users_sessions_on_accessed_at"
    t.index ["revoked_at"], name: "index_users_sessions_on_revoked_at"
    t.index ["token"], name: "index_users_sessions_on_token", unique: true
    t.index ["user_id"], name: "index_users_sessions_on_user_id"
  end

  add_foreign_key "users_activities", "users"
  add_foreign_key "users_activities", "users_sessions", column: "session_id"
  add_foreign_key "users_sessions", "users"
end
