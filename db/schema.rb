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

ActiveRecord::Schema.define(version: 20190306144024) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contact_comments", force: :cascade do |t|
    t.integer  "member_id",        null: false
    t.boolean  "all_activities",   null: false
    t.boolean  "none_activities",  null: false
    t.text     "activity_comment"
    t.text     "contact_comment"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "follow_relations", force: :cascade do |t|
    t.integer  "member_id",  null: false
    t.integer  "follow_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "follow_relations", ["member_id", "follow_id"], name: "index_follow_relations_on_member_id_and_follow_id", unique: true, using: :btree

  create_table "logs", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "member_activities", force: :cascade do |t|
    t.integer  "member_id",   null: false
    t.integer  "activity_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "member_activities", ["member_id", "activity_id"], name: "index_member_activities_on_member_id_and_activity_id", unique: true, using: :btree

  create_table "member_contacts", force: :cascade do |t|
    t.integer  "member_id",  null: false
    t.integer  "contact_id", null: false
    t.string   "account"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "member_contacts", ["member_id", "contact_id"], name: "index_member_contacts_on_member_id_and_contact_id", unique: true, using: :btree

  create_table "member_registers", force: :cascade do |t|
    t.integer  "user_id",       null: false
    t.integer  "member_id"
    t.integer  "grade"
    t.string   "name"
    t.integer  "admin_user_id"
    t.boolean  "is_accept"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "members", force: :cascade do |t|
    t.integer  "grade",      null: false
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  create_table "relations", force: :cascade do |t|
    t.integer  "master_id",     null: false
    t.integer  "apprentice_id", null: false
    t.boolean  "is_primary",    null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "relations", ["master_id", "apprentice_id"], name: "index_relations_on_master_id_and_apprentice_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "token"
    t.string   "name"
    t.boolean  "is_admin",               default: false, null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "url"
    t.string   "image"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

end
