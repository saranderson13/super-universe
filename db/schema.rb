# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_17_001301) do

  create_table "character_powers", force: :cascade do |t|
    t.integer "character_id"
    t.integer "power_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "characters", force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id", default: 0
    t.string "supername"
    t.string "secret_identity"
    t.string "char_type"
    t.string "alignment"
    t.integer "hp"
    t.integer "att"
    t.integer "def"
    t.text "bio"
    t.string "dox_code", default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "moves", force: :cascade do |t|
    t.string "name"
    t.string "move_type"
    t.integer "base_pts"
    t.string "success_descrip"
    t.string "fail_descrip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "power_moves", force: :cascade do |t|
    t.integer "power_id"
    t.integer "move_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "powers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "alias"
    t.string "email"
    t.string "password_digest"
    t.string "profile_pic", default: "default_profile_pic.jpg"
    t.boolean "admin_status", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "google_token"
    t.string "google_refresh_token"
  end

end
