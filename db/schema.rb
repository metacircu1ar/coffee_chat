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

ActiveRecord::Schema[7.0].define(version: 2023_01_20_131217) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chats", force: :cascade do |t|
    t.integer "user_id"
    t.string "topic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "contact_entries", force: :cascade do |t|
    t.integer "contacter_id"
    t.integer "contactee_id"
    t.index ["contactee_id"], name: "index_contact_entries_on_contactee_id"
    t.index ["contacter_id", "contactee_id"], name: "index_contact_entries_on_contacter_id_and_contactee_id", unique: true
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "chat_id"
    t.integer "user_id"
    t.index ["chat_id"], name: "index_memberships_on_chat_id"
    t.index ["user_id", "chat_id"], name: "index_memberships_on_user_id_and_chat_id", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.integer "user_id"
    t.integer "chat_id"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "unread_counts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "chat_id"
    t.integer "count", default: 0, null: false
    t.index ["user_id", "chat_id"], name: "index_unread_counts_on_user_id_and_chat_id", unique: true
    t.index ["user_id"], name: "index_unread_counts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "cookie_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_messages_on_email", unique: true
  end

  add_foreign_key "chats", "users"
  add_foreign_key "memberships", "chats"
  add_foreign_key "memberships", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "users"
  add_foreign_key "unread_counts", "chats"
  add_foreign_key "unread_counts", "users"
  add_foreign_key "contact_entries", "users", column: "contacter_id"
  add_foreign_key "contact_entries", "users", column: "contactee_id"
end
