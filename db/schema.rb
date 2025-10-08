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

ActiveRecord::Schema[8.0].define(version: 2025_10_07_125914) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "glossary_terms", force: :cascade do |t|
    t.string "term", null: false
    t.text "definition", null: false
    t.text "related_categories", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "example_scenario"
    t.index ["term"], name: "index_glossary_terms_on_term", unique: true
  end

  create_table "investment_categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.text "how_it_works"
    t.text "affecting_factors"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_investment_categories_on_slug", unique: true
  end

  create_table "investment_types", force: :cascade do |t|
    t.bigint "investment_category_id", null: false
    t.string "name", null: false
    t.string "ticker_symbol"
    t.decimal "base_price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["investment_category_id"], name: "index_investment_types_on_investment_category_id"
  end

  create_table "portfolios", force: :cascade do |t|
    t.bigint "simulation_id", null: false
    t.bigint "investment_type_id", null: false
    t.integer "quantity", default: 0, null: false
    t.decimal "average_price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["investment_type_id"], name: "index_portfolios_on_investment_type_id"
    t.index ["simulation_id", "investment_type_id"], name: "index_portfolios_on_simulation_id_and_investment_type_id", unique: true
    t.index ["simulation_id"], name: "index_portfolios_on_simulation_id"
  end

  create_table "simulations", force: :cascade do |t|
    t.bigint "investment_type_id", null: false
    t.decimal "initial_capital", precision: 12, scale: 2, null: false
    t.decimal "current_capital", precision: 12, scale: 2, null: false
    t.text "scenario_description"
    t.integer "status", default: 0
    t.integer "months_elapsed", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["investment_type_id"], name: "index_simulations_on_investment_type_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "simulation_id", null: false
    t.integer "action", null: false
    t.integer "quantity", null: false
    t.decimal "price_per_unit", precision: 10, scale: 2, null: false
    t.decimal "total_amount", precision: 12, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["simulation_id"], name: "index_transactions_on_simulation_id"
  end

  add_foreign_key "investment_types", "investment_categories"
  add_foreign_key "portfolios", "investment_types"
  add_foreign_key "portfolios", "simulations"
  add_foreign_key "simulations", "investment_types"
  add_foreign_key "transactions", "simulations"
end
