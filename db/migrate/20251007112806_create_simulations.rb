class CreateSimulations < ActiveRecord::Migration[8.0]
  def change
    create_table :simulations do |t|
      t.references :investment_type, null: false, foreign_key: true
      t.decimal :initial_capital, precision: 12, scale: 2, null: false
      t.decimal :current_capital, precision: 12, scale: 2, null: false
      t.text :scenario_description
      t.integer :status, default: 0
      t.integer :months_elapsed, default: 0

      t.timestamps
    end
  end
end
