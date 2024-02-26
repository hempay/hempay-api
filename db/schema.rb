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

ActiveRecord::Schema[7.1].define(version: 2024_02_26_032946) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "currencies", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_currencies_on_code", unique: true
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
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "payments", "currencies", column: "currency_code", primary_key: "code"
  add_foreign_key "payments_users", "users", column: "receiver_id"
  add_foreign_key "payments_users", "users", column: "sender_id"
end
