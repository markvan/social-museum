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

ActiveRecord::Schema.define(version: 20160608183346) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree

  create_table "category_items", force: true do |t|
    t.integer  "categorisable_id"
    t.string   "categorisable_type"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "category_items", ["categorisable_id", "categorisable_type", "category_id"], name: "index_unique_categories_on_categorisables", unique: true, using: :btree

  create_table "collection_items", force: true do |t|
    t.text     "description"
    t.string   "location"
    t.string   "item_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version"
    t.integer  "user_id"
    t.string   "name"
    t.integer  "creator_id"
    t.integer  "last_editor_id"
  end

  add_index "collection_items", ["name"], name: "index_collection_items_on_name", unique: true, using: :btree

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "page_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_ip"
    t.string   "user_agent"
    t.string   "referrer"
    t.boolean  "approved",         default: false, null: false
    t.boolean  "notified",         default: false
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "creator_id"
    t.integer  "last_editor_id"
  end

  add_index "comments", ["page_id"], name: "index_comments_on_page_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "pages", force: true do |t|
    t.text     "description"
    t.integer  "lock_version"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "creator_id"
    t.integer  "last_editor_id"
  end

  add_index "pages", ["name"], name: "index_pages_on_name", unique: true, using: :btree

  create_table "related_collection_items", force: true do |t|
    t.integer  "source_collection_item_id"
    t.string   "relation_type"
    t.integer  "target_collection_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resource_usages", force: true do |t|
    t.integer "resource_id"
    t.integer "resourceable_id"
    t.string  "resourceable_type"
  end

  add_index "resource_usages", ["resource_id"], name: "index_resource_usages_on_resource_id", using: :btree

  create_table "resources", force: true do |t|
    t.string   "file"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "copyright_holder"
    t.string   "licence"
    t.string   "source"
    t.string   "url"
    t.integer  "user_id"
    t.integer  "lock_version"
    t.string   "name"
    t.integer  "creator_id"
    t.integer  "last_editor_id"
  end

  add_index "resources", ["name"], name: "index_resources_on_name", unique: true, using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer "user_id"
    t.integer "subscribable_id"
    t.string  "subscribable_type"
  end

  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "tag_items", force: true do |t|
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tag_items", ["taggable_id", "taggable_type", "tag_id"], name: "index_tag_items_on_taggable_id_and_taggable_type_and_tag_id", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string "name", null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "titles", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "titleable_id"
    t.string   "titleable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "titles", ["slug"], name: "index_titles_on_slug", unique: true, using: :btree
  add_index "titles", ["title"], name: "index_titles_on_title", unique: true, using: :btree
  add_index "titles", ["titleable_type", "titleable_id"], name: "index_titles_on_titleable_type_and_titleable_id", using: :btree

  create_table "uploads", force: true do |t|
    t.string   "type"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "admin",                  default: false
    t.string   "provider"
    t.string   "uid"
    t.string   "remember_token"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "track_created_pages"
    t.boolean  "track_commented_pages"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.integer  "version_number"
    t.string   "versioned_type"
    t.integer  "versioned_id"
    t.integer  "user_id"
    t.text     "description"
    t.text     "object_changes"
    t.datetime "created_at"
  end

  add_index "versions", ["created_at"], name: "index_versions_on_created_at", using: :btree
  add_index "versions", ["user_id"], name: "index_versions_on_user_id", using: :btree
  add_index "versions", ["version_number"], name: "index_versions_on_version_number", using: :btree
  add_index "versions", ["versioned_type", "versioned_id"], name: "index_versions_on_versioned_type_and_versioned_id", using: :btree

end
