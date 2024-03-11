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

ActiveRecord::Schema[7.1].define(version: 2024_03_11_194834) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.float "balance", default: 0.0
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "fixeds", force: :cascade do |t|
    t.integer "periodicity"
    t.float "amount"
    t.string "category"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "income"
    t.string "title"
    t.datetime "start_date"
    t.index ["account_id"], name: "index_fixeds_on_account_id"
  end

  create_table "plans", force: :cascade do |t|
    t.float "goal"
    t.string "title"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.datetime "date"
    t.index ["user_id"], name: "index_plans_on_user_id"
  end

  create_table "records", force: :cascade do |t|
    t.float "amount"
    t.string "category", default: "0"
    t.string "note"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "result"
    t.boolean "income"
    t.bigint "plan_id"
    t.index ["account_id"], name: "index_records_on_account_id"
    t.index ["plan_id"], name: "index_records_on_plan_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nickname"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "fixeds", "accounts"
  add_foreign_key "plans", "users"
  add_foreign_key "records", "accounts"
  add_foreign_key "records", "plans"
end
