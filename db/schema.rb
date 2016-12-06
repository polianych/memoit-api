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

ActiveRecord::Schema.define(version: 20161206130202) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "password_resets", force: :cascade do |t|
    t.string   "uri"
    t.string   "token_hash"
    t.datetime "expiry"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uri"], name: "index_password_resets_on_uri", unique: true, using: :btree
    t.index ["user_id"], name: "index_password_resets_on_user_id", using: :btree
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.string   "postable_type"
    t.integer  "postable_id"
    t.string   "publisher_type"
    t.integer  "publisher_id"
    t.datetime "published_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["postable_type", "postable_id"], name: "index_posts_on_postable_type_and_postable_id", using: :btree
    t.index ["publisher_type", "publisher_id"], name: "index_posts_on_publisher_type_and_publisher_id", using: :btree
  end

  create_table "rss_categories", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rss_channels", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.string   "url"
    t.string   "image_url"
    t.integer  "rss_category_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "slug"
    t.index ["rss_category_id"], name: "index_rss_channels_on_rss_category_id", using: :btree
  end

  create_table "rss_posts", force: :cascade do |t|
    t.string   "link"
    t.string   "media_thumbnail"
    t.string   "guid"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "publisher_type"
    t.integer  "publisher_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["publisher_type", "publisher_id"], name: "index_subscriptions_on_publisher_type_and_publisher_id", using: :btree
    t.index ["user_id"], name: "index_subscriptions_on_user_id", using: :btree
  end

  create_table "user_posts", force: :cascade do |t|
    t.string   "link"
    t.string   "image_url"
    t.string   "video_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "client"
    t.datetime "expiry"
    t.string   "token_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_tokens_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "nickname"
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "uid"
    t.string   "provider"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "password_resets", "users"
  add_foreign_key "rss_channels", "rss_categories"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "user_tokens", "users"
end
