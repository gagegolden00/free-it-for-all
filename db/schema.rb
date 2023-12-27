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

ActiveRecord::Schema[7.0].define(version: 2023_12_13_194011) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "intarray"
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "role", ["admin", "technician"]
  create_enum "service_job_status", ["Open", "Assigned", "Waiting on parts", "In progress", "On hold", "Completed"]

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.timestamptz "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.timestamptz "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone_number"
    t.string "email"
    t.string "address"
    t.string "city"
    t.string "state"
    t.integer "zip_code"
    t.bigint "region_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.timestamptz "discarded_at"
    t.index ["discarded_at"], name: "index_customers_on_discarded_at"
    t.index ["region_id"], name: "index_customers_on_region_id"
  end

  create_table "materials", force: :cascade do |t|
    t.string "name", null: false
    t.integer "price", null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.timestamptz "discarded_at"
    t.index ["discarded_at"], name: "index_materials_on_discarded_at"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "type", null: false
    t.jsonb "params"
    t.timestamptz "read_at", precision: 6
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable"
  end

  create_table "point_of_contacts", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone_number"
    t.string "email"
    t.bigint "customer_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.timestamptz "discarded_at"
    t.index ["customer_id"], name: "index_point_of_contacts_on_customer_id"
    t.index ["discarded_at"], name: "index_point_of_contacts_on_discarded_at"
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.string "purchase_order_number", null: false
    t.string "vendor"
    t.text "description"
    t.integer "quantity"
    t.integer "price"
    t.integer "total_price"
    t.text "notes"
    t.text "internal_notes"
    t.bigint "service_report_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.timestamptz "discarded_at"
    t.index ["discarded_at"], name: "index_purchase_orders_on_discarded_at"
    t.index ["service_report_id"], name: "index_purchase_orders_on_service_report_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name", null: false
    t.string "manager", null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.timestamptz "discarded_at"
    t.index ["discarded_at"], name: "index_regions_on_discarded_at"
  end

  create_table "service_jobs", force: :cascade do |t|
    t.string "job_number", null: false
    t.enum "status", default: "Open", null: false, enum_type: "service_job_status"
    t.text "description"
    t.integer "contract_amount"
    t.string "work_type"
    t.bigint "customer_id"
    t.bigint "work_site_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.timestamptz "discarded_at"
    t.index ["customer_id"], name: "index_service_jobs_on_customer_id"
    t.index ["discarded_at"], name: "index_service_jobs_on_discarded_at"
    t.index ["work_site_id"], name: "index_service_jobs_on_work_site_id"
  end

  create_table "service_report_materials", force: :cascade do |t|
    t.bigint "service_report_id", null: false
    t.bigint "material_id", null: false
    t.integer "quantity", null: false
    t.integer "pre_tax_total"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.timestamptz "discarded_at"
    t.index ["discarded_at"], name: "index_service_report_materials_on_discarded_at"
    t.index ["material_id"], name: "index_service_report_materials_on_material_id"
    t.index ["service_report_id", "material_id"], name: "unique_index_on_service_report_and_material", unique: true
    t.index ["service_report_id"], name: "index_service_report_materials_on_service_report_id"
  end

  create_table "service_reports", force: :cascade do |t|
    t.string "service_report_number", null: false
    t.boolean "warranty"
    t.string "equipment_model"
    t.string "equipment_serial"
    t.integer "mischarge"
    t.integer "total_charge"
    t.text "description"
    t.text "employee_signature"
    t.text "customer_signature"
    t.bigint "service_job_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.timestamptz "discarded_at"
    t.bigint "user_id"
    t.index ["discarded_at"], name: "index_service_reports_on_discarded_at"
    t.index ["service_job_id"], name: "index_service_reports_on_service_job_id"
  end

  create_table "time_logs", force: :cascade do |t|
    t.integer "regular_minutes"
    t.integer "overtime_minutes"
    t.integer "double_time_minutes"
    t.integer "mileage"
    t.text "remarks"
    t.bigint "service_report_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.timestamptz "discarded_at"
    t.bigint "user_id"
    t.index ["service_report_id"], name: "index_time_logs_on_service_report_id"
  end

  create_table "user_service_jobs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "service_job_id", null: false
    t.date "date"
    t.time "start_time"
    t.time "end_time"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.timestamptz "discarded_at"
    t.index ["discarded_at"], name: "index_user_service_jobs_on_discarded_at"
    t.index ["service_job_id"], name: "index_user_service_jobs_on_service_job_id"
    t.index ["user_id", "service_job_id"], name: "index_user_service_jobs_on_user_id_and_service_job_id", unique: true
    t.index ["user_id"], name: "index_user_service_jobs_on_user_id"
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
    t.timestamptz "reset_password_sent_at"
    t.timestamptz "remember_created_at"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
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
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.timestamptz "discarded_at"
    t.index ["discarded_at"], name: "index_work_sites_on_discarded_at"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "purchase_orders", "service_reports"
  add_foreign_key "service_jobs", "customers"
  add_foreign_key "service_report_materials", "materials"
  add_foreign_key "service_report_materials", "service_reports"
  add_foreign_key "service_reports", "service_jobs"
  add_foreign_key "service_reports", "users"
  add_foreign_key "time_logs", "service_reports"
  add_foreign_key "time_logs", "users"
end
