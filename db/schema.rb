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

ActiveRecord::Schema[7.1].define(version: 2024_02_26_104408) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audit_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "action"
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "symbol"
    t.decimal "exchange_rate", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_currencies_on_code", unique: true
  end

  create_table "hempay_accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_hempay_accounts_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount"
    t.date "payment_date"
    t.string "description"
    t.string "status"
    t.string "currency_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "payment_id", null: false
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.index ["payment_id", "user_id"], name: "index_payments_users_on_payment_id_and_user_id"
    t.index ["receiver_id"], name: "index_payments_users_on_receiver_id"
    t.index ["sender_id"], name: "index_payments_users_on_sender_id"
    t.index ["user_id", "payment_id"], name: "index_payments_users_on_user_id_and_payment_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "avatar"
    t.string "first_name"
    t.string "last_name"
    t.string "middle_name"
    t.date "date_of_birth"
    t.string "employment_status"
    t.string "bvn"
    t.boolean "kyc_status"
    t.string "home_address"
    t.string "office_address"
    t.string "phone_number"
    t.boolean "can_transact"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "audit_logs", "users"
  add_foreign_key "hempay_accounts", "users"
  add_foreign_key "payments", "currencies", column: "currency_code", primary_key: "code"
  add_foreign_key "payments_users", "users", column: "receiver_id"
  add_foreign_key "payments_users", "users", column: "sender_id"
end
