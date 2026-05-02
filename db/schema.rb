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

ActiveRecord::Schema[8.1].define(version: 2026_05_02_041119) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "home_searches", force: :cascade do |t|
    t.integer "area_max"
    t.integer "area_min"
    t.datetime "created_at", null: false
    t.integer "price_max"
    t.integer "price_min"
    t.integer "rooms"
    t.datetime "updated_at", null: false
  end

  create_table "job_searches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "mode"
    t.string "query", null: false
    t.integer "salary_max"
    t.integer "salary_min"
    t.string "seniority"
    t.datetime "updated_at", null: false
  end

  create_table "searches", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "notes"
    t.bigint "searchable_id", null: false
    t.string "searchable_type", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_searches_on_searchable"
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "sources", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "base_url", null: false
    t.datetime "created_at", null: false
    t.string "kind", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["base_url"], name: "index_sources_on_base_url", unique: true
    t.index ["kind"], name: "index_sources_on_kind"
    t.index ["name"], name: "index_sources_on_name", unique: true
    t.index ["slug"], name: "index_sources_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "searches", "users"
  add_foreign_key "sessions", "users"
end
