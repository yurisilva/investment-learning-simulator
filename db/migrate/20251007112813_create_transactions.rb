class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :simulation, null: false, foreign_key: true
      t.integer :action, null: false
      t.integer :quantity, null: false
      t.decimal :price_per_unit, precision: 10, scale: 2, null: false
      t.decimal :total_amount, precision: 12, scale: 2, null: false

      t.timestamps
    end
  end
end
