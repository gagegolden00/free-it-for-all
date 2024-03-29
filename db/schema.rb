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

ActiveRecord::Schema[7.0].define(version: 2024_02_02_170603) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ipv4_quizzes", force: :cascade do |t|
    t.string "quiz_type", default: "ipv4_quiz"
    t.integer "quiz_number", null: false
    t.integer "question_count", null: false
    t.integer "attempts", default: 0, null: false
    t.bigint "user_id"
    t.timestamptz "created_at", precision: 6, null: false
    t.timestamptz "updated_at", precision: 6, null: false
    t.boolean "updateable", default: true
    t.index ["user_id"], name: "index_ipv4_quizzes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.timestamptz "reset_password_sent_at", precision: 6
    t.timestamptz "remember_created_at", precision: 6
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
