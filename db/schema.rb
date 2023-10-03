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

ActiveRecord::Schema[7.0].define(version: 2023_10_02_134047) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "intarray"
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

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
    t.string "name"
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
    t.string "name"
    t.string "manager"
    t.timestamptz "created_at", precision: 6, null: false
    t.timestamptz "updated_at", precision: 6, null: false
    t.timestamptz "discarded_at"
    t.index ["discarded_at"], name: "index_regions_on_discarded_at"
  end

  add_foreign_key "customers", "regions"
  add_foreign_key "point_of_contacts", "customers"
end
