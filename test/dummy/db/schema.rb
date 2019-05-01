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

ActiveRecord::Schema.define(version: 2019_05_01_141638) do

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_doohickeys", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "doohickey_id", null: false
    t.index ["category_id", "doohickey_id"], name: "index_categories_doohickeys_on_category_id_and_doohickey_id"
    t.index ["doohickey_id", "category_id"], name: "index_categories_doohickeys_on_doohickey_id_and_category_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "message"
    t.integer "doohickey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doohickey_id"], name: "index_comments_on_doohickey_id"
  end

  create_table "doohickeys", force: :cascade do |t|
    t.string "title"
    t.float "weight"
    t.integer "amount"
    t.boolean "available"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ez_crud_doohickeys", force: :cascade do |t|
    t.string "title"
    t.float "weight"
    t.integer "amount"
    t.boolean "available"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ez_crud_job_specs", force: :cascade do |t|
    t.string "type", limit: 50
    t.string "model_type", limit: 50
    t.text "search"
    t.text "updates"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
