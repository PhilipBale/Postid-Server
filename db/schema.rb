# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160411224054) do

  create_table "fires", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.integer "friendable_id"
    t.integer "friend_id"
    t.integer "blocker_id"
    t.boolean "pending",       default: true
  end

  add_index "friendships", ["friendable_id", "friend_id"], name: "index_friendships_on_friendable_id_and_friend_id", unique: true

  create_table "hearts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "from_id"
    t.string   "message"
    t.integer  "post_id"
    t.integer  "notification_type"
    t.boolean  "viewed"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id",                            null: false
    t.string   "image_url",                          null: false
    t.integer  "view_count",         default: 0
    t.integer  "heart_count",        default: 0
    t.integer  "smirk_count",        default: 0
    t.integer  "fire_count",         default: 0
    t.string   "created_ip_address", default: ""
    t.integer  "like_count",         default: 0
    t.integer  "likes_needed",       default: 0
    t.boolean  "flagged",            default: false
    t.boolean  "approved",           default: false
    t.boolean  "deleted",            default: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "posts_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
  end

  create_table "smirks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",                      null: false
    t.string   "last_name",                       null: false
    t.string   "username",                        null: false
    t.string   "email",                           null: false
    t.string   "password_hash",                   null: false
    t.string   "token",           default: ""
    t.integer  "check_ins",       default: 1
    t.integer  "posts_created",   default: 1
    t.string   "last_ip_address", default: ""
    t.boolean  "admin",           default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "phone_number",    default: ""
    t.string   "image_url",       default: ""
  end

end
