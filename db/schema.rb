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

ActiveRecord::Schema[7.0].define(version: 2023_10_04_203410) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "intarray"
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "role", ["admin", "technician"]

  create_table "customers", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone_number"
    t.string "email"
    t.string "address"
    t.string "city"
    t.string "state"
    t.integer "zipcode"
    t.bigint "region_id"
    t.timestamptz "created_at", precision: 6, null: false
    t.timestamptz "updated_at", precision: 6, null: false
    t.timestamptz "discarded_at"
    t.index ["discarded_at"], name: "index_customers_on_discarded_at"
    t.index ["region_id"], name: "index_customers_on_region_id"
  end

  create_table "point_of_contacts", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone_number"
    t.string "email"
    t.bigint "customer_id"
    t.timestamptz "created_at", precision: 6, null: false
    t.timestamptz "updated_at", precision: 6, null: false
    t.timestamptz "discarded_at"
    t.index ["customer_id"], name: "index_point_of_contacts_on_customer_id"
    t.index ["discarded_at"], name: "index_point_of_contacts_on_discarded_at"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name", null: false
    t.string "manager", null: false
    t.timestamptz "created_at", precision: 6, null: false
    t.timestamptz "updated_at", precision: 6, null: false
    t.timestamptz "discarded_at"
    t.index ["discarded_at"], name: "index_regions_on_discarded_at"
  end

  create_table "users", force: :cascade do |t|
    t.enum "role", null: false, enum_type: "role"
    t.string "name", null: false
    t.string "home_phone"
    t.string "work_phone"
    t.string "carrier"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.date "hire_date"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.timestamptz "reset_password_sent_at", precision: 6
    t.timestamptz "remember_created_at", precision: 6
    t.timestamptz "created_at", precision: 6, null: false
    t.timestamptz "updated_at", precision: 6, null: false
    t.timestamptz "discarded_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
