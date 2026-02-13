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

ActiveRecord::Schema[8.1].define(version: 2026_02_13_024736) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "currency", default: "USD", null: false
    t.string "customer_name", null: false
    t.string "external_id"
    t.text "last_sync_error"
    t.datetime "last_synced_at"
    t.string "status", default: "draft", null: false
    t.string "sync_status", default: "pending", null: false
    t.integer "total_cents", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_orders_on_external_id", unique: true, where: "(external_id IS NOT NULL)"
    t.index ["status"], name: "index_orders_on_status"
    t.index ["sync_status"], name: "index_orders_on_sync_status"
  end
end
