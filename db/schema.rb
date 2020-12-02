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

ActiveRecord::Schema.define(version: 2020_12_02_165008) do

  create_table "battles", force: :cascade do |t|
    t.integer "protag_id"
    t.integer "antag_id"
    t.string "outcome", default: "Pending"
    t.integer "points", default: 0
    t.integer "turn_count", default: 0
    t.text "log", default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "p_hp"
    t.integer "a_hp"
    t.boolean "p_used_pwrmv", default: false
    t.boolean "a_used_pwrmv", default: false
    t.index ["antag_id"], name: "index_battles_on_antag_id"
    t.index ["protag_id"], name: "index_battles_on_protag_id"
  end

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
    t.integer "level", default: 1
    t.integer "pts_to_next_lvl", default: 10
    t.integer "lvl_progress", default: 0
    t.integer "victories", default: 0
    t.integer "defeats", default: 0
  end

  create_table "followers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "following"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_followers_on_user_id"
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

  create_table "news_items", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "homepage", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "indexpage", default: true
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
    t.string "pwr_type"
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
