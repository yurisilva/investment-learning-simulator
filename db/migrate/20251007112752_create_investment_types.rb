class CreateInvestmentTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :investment_types do |t|
      t.references :investment_category, null: false, foreign_key: true
      t.string :name, null: false
      t.string :ticker_symbol
      t.decimal :base_price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
