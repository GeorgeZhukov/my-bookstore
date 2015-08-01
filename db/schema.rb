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

ActiveRecord::Schema.define(version: 20150801175330) do

  create_table "addresses", force: :cascade do |t|
    t.text     "address"
    t.string   "zip_code"
    t.string   "city"
    t.string   "phone"
    t.integer  "user_id"
    t.string   "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id"

  create_table "authors", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.text     "biography"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "photo"
  end

  create_table "books", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.decimal  "price",             precision: 8, scale: 2
    t.integer  "books_in_stock"
    t.text     "short_description"
    t.integer  "author_id"
    t.integer  "category_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "cover"
  end

  add_index "books", ["author_id"], name: "index_books_on_author_id"
  add_index "books", ["category_id"], name: "index_books_on_category_id"

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "credit_cards", force: :cascade do |t|
    t.string   "number"
    t.string   "CVV"
    t.integer  "expiration_month"
    t.integer  "expiration_year"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "credit_cards", ["user_id"], name: "index_credit_cards_on_user_id"

  create_table "delivery_services", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price",      precision: 8, scale: 2
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.decimal  "price",      precision: 8, scale: 2
    t.integer  "quantity"
    t.integer  "book_id"
    t.integer  "order_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "order_items", ["book_id"], name: "index_order_items_on_book_id"
  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id"

  create_table "orders", force: :cascade do |t|
    t.datetime "completed_date"
    t.string   "state"
    t.integer  "user_id"
    t.integer  "delivery_service_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "credit_card_id"
    t.integer  "shipping_address_id"
    t.integer  "billing_address_id"
  end

  add_index "orders", ["credit_card_id"], name: "index_orders_on_credit_card_id"
  add_index "orders", ["delivery_service_id"], name: "index_orders_on_delivery_service_id"
  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "ratings", force: :cascade do |t|
    t.text     "review"
    t.integer  "number"
    t.integer  "book_id"
    t.integer  "user_id"
    t.string   "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ratings", ["book_id"], name: "index_ratings_on_book_id"
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "avatar"
    t.boolean  "is_admin"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "shipping_address_id"
    t.integer  "billing_address_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["provider"], name: "index_users_on_provider"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["uid"], name: "index_users_on_uid"

end
