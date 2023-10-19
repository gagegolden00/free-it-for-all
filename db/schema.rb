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

ActiveRecord::Schema[7.0].define(version: 2023_10_12_132739) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "intarray"
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "role", ["admin", "technician"]
  create_enum "status", ["Pending", "Not started", "In progress", "On hold", "Completed"]

  create_table "customers", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone_number"
    t.string "email"
    t.string "address"
    t.string "city"
    t.string "state"
    t.integer "zip_code"
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

  create_table "service_jobs", force: :cascade do |t|
    t.string "job_number", null: false
    t.enum "status", default: "Pending", null: false, enum_type: "status"
    t.text "description"
    t.decimal "contract_amount"
    t.string "work_type"
    t.bigint "customer_id"
    t.bigint "work_site_id"
    t.timestamptz "created_at", precision: 6, null: false
    t.timestamptz "updated_at", precision: 6, null: false
    t.timestamptz "discarded_at"
    t.index ["customer_id"], name: "index_service_jobs_on_customer_id"
    t.index ["discarded_at"], name: "index_service_jobs_on_discarded_at"
    t.index ["work_site_id"], name: "index_service_jobs_on_work_site_id"
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
    t.string "zip_code"
    t.date "hire_date"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.timestamptz "reset_password_sent_at", precision: 6
    t.timestamptz "remember_created_at", precision: 6
    t.timestamptz "created_at", precision: 6, null: false
    t.timestamptz "updated_at", precision: 6, null: false
    t.timestamptz "discarded_at"
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "work_sites", force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.string "city"
    t.string "state"
    t.integer "zip_code"
    t.string "email"
    t.string "phone_number"
    t.timestamptz "created_at", precision: 6, null: false
    t.timestamptz "updated_at", precision: 6, null: false
    t.timestamptz "discarded_at"
    t.index ["discarded_at"], name: "index_work_sites_on_discarded_at"
  end

  add_foreign_key "service_jobs", "customers"
  add_foreign_key "service_jobs", "work_sites"
end
